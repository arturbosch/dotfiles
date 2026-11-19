# sandbox via bubblewrap
# caller mounts are plain bwrap flags appended after the fixed ones; bwrap stops
# parsing options at the command, so `sandbox --bind-try /a /a cmd` just works
function sandbox
    # realpath, not pwd: a symlinked path would pass the string checks below
    # while bwrap binds the directory it actually points at
    set -l cwd (realpath .)
    set -l home (realpath $HOME)

    # --bind $cwd is what makes the project writable — the agent inherits
    # everything $cwd exposes, so allowlist where that may happen instead of
    # enumerating what must not: a denylist is incomplete by construction (the
    # next tool that drops a credential dir under $HOME escapes it), and the
    # dangerous cases all collapse here — / and $HOME itself would expose the
    # whole home, ~/.ssh makes authorized_keys plantable, ~/.gnupg exfiltrates
    # the private keyring over the shared network, a fixed-mount subtree like
    # /run/user/<uid> hands over the host session sockets (wayland, dbus,
    # pipewire). Nothing outside a listed root is ever bound writable; a new
    # project means adding a root, nothing to keep updated on the danger side.
    # Override: SANDBOX_ALLOW=$cwd exempts this one directory from the whole
    # check — an explicit "I know what this exposes" door for wrappers that
    # apply their own guards (pie does, ro-binding auth.json and guard.list)
    set -l project_roots \
        $HOME/dotfiles \
        $HOME/git \
        $HOME/homelab \
        $HOME/Repos \
        $HOME/share
    set -l allowed false
    for r in $project_roots
        if test "$cwd" = "$r"; or string match -q -- "$r/*" "$cwd"
            set allowed true
        end
    end
    if test "$allowed" = false; and test "$SANDBOX_ALLOW" = "$cwd"
        set allowed true
    end
    if test "$allowed" = false
        echo "sandbox: refusing to bind $cwd writable, cd into a project root" >&2
        return 1
    end

    # wayland: expose only the display socket (wl-copy/wl-paste), skipped if none.
    # "read-only" restricts the mount only — a unix-socket connect ignores it, so
    # what the compositor grants over the protocol is up to the compositor.
    # accepted residual, like the shared network below. the env vars are set
    # explicitly because $env_args below clears everything uninvited
    set -l wayland_args
    if test -n "$WAYLAND_DISPLAY"; and test -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"
        set wayland_args --ro-bind "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" \
            --setenv XDG_RUNTIME_DIR "$XDG_RUNTIME_DIR" --setenv WAYLAND_DISPLAY "$WAYLAND_DISPLAY"
    end

    # ssh agent: there may be no agent at all — skip the group when there is none.
    # The socket itself is bound, not its dir: on systemd setups the dir is
    # $XDG_RUNTIME_DIR and would expose every other runtime socket (wayland,
    # pipewire, dbus) that the mounts below carefully do not. An agent restarted
    # after this point mints a new socket — restart the sandbox to pick it up
    set -l ssh_args
    if set -q SSH_AUTH_SOCK; and test -S "$SSH_AUTH_SOCK"
        set ssh_args --ro-bind $SSH_AUTH_SOCK $SSH_AUTH_SOCK --setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
    end

    # ssh: host root is unmapped inside the sandbox, so everything it owns shows
    # up as nobody and ssh refuses included config files it does not trust ("Bad
    # owner or permissions"). Hide the distro's include dir: openSUSE keeps the
    # vendor config in /usr/etc, Fedora in /etc. Only dirs that exist on the host
    # can be tmpfs'd over the read-only binds.
    set -l ssh_confdirs
    for dir in /etc/ssh/ssh_config.d /usr/etc/ssh/ssh_config.d
        test -d $dir; and set -a ssh_confdirs --tmpfs $dir
    end

    # tool-broker capability for the repo in $cwd, if the broker has a socket for it
    set -l forgejo_args
    set -l forgejo_socket (project_forgejo_socket)
    if test -n "$forgejo_socket"
        set forgejo_args --ro-bind-try $forgejo_socket /run/tool-broker/forgejo.sock
    end

    # terminal capability: the broker opens fish/hx/pi on the host; the sandbox
    # still does not get the kitty control socket (that would allow `kitten @ run`)
    set -l term_args
    if test -S ~/.local/run/tool-broker/term.sock
        set term_args --ro-bind ~/.local/run/tool-broker/term.sock /run/tool-broker/term.sock
    end

    # worktrees: nested in the repo at .worktrees/<slug> — gitignored, so they sit
    # on the host under the existing $cwd bind and the human can cd in and build
    # with no extra mount. Only a session *started inside* a worktree needs help:
    # a linked worktree keeps its state in the main worktree's .git and with just
    # $cwd bound git says "not a git repository".
    #
    # .git itself stays writable: git creates lock files in its root
    # (packed-refs.lock, gc.pid.lock) and rename() does not cross a bind mount, so
    # a read-only .git with writable objects/refs/worktrees cannot work. hooks/
    # and config/ are read-only instead — they are what makes the host execute
    # code (hooks, core.fsmonitor, core.pager, core.hooksPath, url.*.insteadOf).
    set -l worktree_args
    set -l git_guard_args
    set -l git_dir (git rev-parse --path-format=absolute --git-dir 2>/dev/null)
    set -l common_dir (git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
    if test -n "$git_dir"; and test -n "$common_dir"
        set -l main_root (dirname $common_dir)
        set -a worktree_args --setenv SANDBOX_WORKTREE_ROOT $main_root/.worktrees
        # before $cwd: the main worktree is an ancestor of a nested worktree, so
        # its read-only bind has to be overridden by the $cwd bind that follows
        if test "$git_dir" != "$common_dir"
            set -a worktree_args --ro-bind $main_root $main_root --bind $common_dir $common_dir
        end
        # after $cwd: these override the writable $cwd and .git binds
        # both must exist on the host first: --ro-bind-try would skip a missing
        # one and leave .git writable enough to plant it for the next host run
        mkdir -p $common_dir/hooks
        touch $common_dir/config
        set -a git_guard_args \
            --ro-bind $common_dir/hooks $common_dir/hooks \
            --ro-bind $common_dir/config $common_dir/config
    end

    # gradle/maven: caches and logs stay writable, but what a *host* build then
    # executes or obeys is mounted read-only instead — gradle applies init.gradle,
    # init.d/* and gradle.properties on every host build, and wrapper/dists holds
    # the distribution a host-side ./gradlew actually executes; maven's
    # settings.xml can carry <server>/<proxy> credentials, so it is only exposed
    # when it has none. Guarded paths must exist on the host first: --ro-bind-try
    # would skip a missing one and leave it plantable through the writable parent
    # bind. An empty one on the host is inert. The read-only dists mean a wrapper
    # inside cannot download a new gradle version — fetch it on the host once.
    set -l gradle_args
    if test -d ~/.gradle
        mkdir -p ~/.gradle/init.d ~/.gradle/wrapper/dists
        touch ~/.gradle/init.gradle ~/.gradle/gradle.properties
        set gradle_args \
            --bind ~/.gradle ~/.gradle \
            --ro-bind ~/.gradle/init.gradle ~/.gradle/init.gradle \
            --ro-bind ~/.gradle/init.d ~/.gradle/init.d \
            --ro-bind ~/.gradle/wrapper/dists ~/.gradle/wrapper/dists \
            --ro-bind ~/.gradle/gradle.properties ~/.gradle/gradle.properties
    end
    set -l mvn_args --bind-try ~/.mvn ~/.mvn
    if test -f ~/.m2/settings.xml; and not grep -qE '<(server|proxy)' ~/.m2/settings.xml
        set -a mvn_args --ro-bind ~/.m2/settings.xml ~/.m2/settings.xml
    end

    # environment: --clearenv first, then an explicit allowlist — nothing from
    # the host env passes through uninvited (secrets routinely live there:
    # GITHUB_TOKEN, ANTHROPIC_API_KEY, AWS_*, …). --setenv ops apply in argument
    # order, so everything set after $env_args (SSH_AUTH_SOCK, GIT_SSH_COMMAND,
    # the wayland vars) survives the clear
    set -l env_args \
        --clearenv \
        --setenv PATH (string join : $PATH) \
        --setenv HOME "$HOME" \
        --setenv USER "$USER"
    for var in TERM COLORTERM LANG LC_ALL
        if set -q $var
            set -a env_args --setenv $var $$var
        end
    end

    echo "Entering sandbox for $cwd" >&2

    bwrap \
        --die-with-parent \
        # own pid namespace: host processes invisible, no signals into the session;
        # bwrap becomes pid 1 and our command pid 2, so it is signal-inert — kill -9
        # the wrapper or ^C the terminal to stop a sandbox
        --unshare-pid \
        # new session (setsid): blocks TIOCSTI terminal injection (CVE-2017-5226).
        # costless here — /dev/tty is already absent because /dev is a fresh devtmpfs
        --new-session \
        # no SysV shm/sem/msg queues shared with the host session; hostname isolated
        --unshare-ipc \
        --unshare-uts \
        # network is deliberately NOT unshared: the agent needs egress. accepted
        # residual: everything readable inside (auth.json, the ssh agent, the
        # wayland socket) is exfiltratable over it
        # system (read-only)
        --ro-bind /usr /usr \
        --ro-bind /bin /bin \
        --ro-bind /lib /lib \
        --ro-bind /lib64 /lib64 \
        --ro-bind /etc /etc \
        # the trust store: on openSUSE /etc/ssl/{certs,ca-bundle.pem} are
        # symlinks into here, and node's built-in root store on this distro is
        # trimmed — no GTS Root R4 — so TLS verification of the model providers
        # falls through to the system bundle; without this mount the symlinks
        # dangle and every https request dies with UNABLE_TO_GET_ISSUER_CERT_LOCALLY.
        # Fedora has no /var/lib/ca-certificates (store lives under /etc/pki/tls,
        # already covered by the /etc bind) — -try skips the bind there instead of
        # aborting bwrap. Nothing mounts /var/lib writable, so a missing one is
        # not plantable and the exist-first rule does not apply
        --ro-bind-try /var/lib/ca-certificates /var/lib/ca-certificates \
        --tmpfs /var/tmp \
        # user bins/libs (read-only)
        --ro-bind ~/.local/bin ~/.local/bin \
        --ro-bind ~/.local/lib ~/.local/lib \
        --ro-bind ~/.sdkman ~/.sdkman \
        # sharing dir
        --bind ~/share ~/share \
        # project
        $worktree_args \
        --bind $cwd $cwd \
        $git_guard_args \
        # build tool state
        $gradle_args \
        $mvn_args \
        ## dotfiles is always okay as reference
        --ro-bind ~/dotfiles ~/dotfiles \
        # ephemeral (tmpfs)
        --tmpfs ~/.config \
        --tmpfs ~/.local/share \
        --tmpfs ~/.local/state \
        --tmpfs ~/.cache \
        --tmpfs /tmp \
        # DNS (target of the /etc/resolv.conf symlink on Fedora)
        --ro-bind-try /run/systemd/resolve /run/systemd/resolve \
        # devices: only a minimal devtmpfs (includes pts, so ptys work) — binding
        # all of /dev would hand out /dev/uinput (synthetic input into the host
        # session), hidraw, gpiochip, kvm. No GPU nodes either: nothing with a
        # renderer runs inside anymore, the broker opens hx/fish on the host
        --dev /dev \
        # process info
        --proc /proc \
        # environment: explicit allowlist, see $env_args
        $env_args \
        # git
        --ro-bind-try ~/.gitconfig ~/.gitconfig \
        --ro-bind-try ~/.ssh/known_hosts ~/.ssh/known_hosts \
        --ro-bind-try ~/.ssh/config ~/.ssh/config \
        $ssh_args \
        # ssh: hide the untrusted include dirs (see $ssh_confdirs above) and skip
        # the system config for git; keys come from the agent, known_hosts from
        # the bind above, ~/.ssh/config is still honoured for plain ssh
        $ssh_confdirs \
        --setenv GIT_SSH_COMMAND 'ssh -F /dev/null' \
        # wayland clipboard
        $wayland_args \
        # tool-broker capability (agent agnostic)
        $forgejo_args \
        $term_args \
        # caller mounts, then the command
        --chdir $cwd \
        $argv
end

# tool-broker capabilities: the broker holds the tokens, the sandbox gets only
# the socket of the project it is working on — never the whole toolsocks/ dir.
# The mount destination is fixed and literal, so the client inside needs no flag,
# no environment and no home: /run here is the sandbox's own tmpfs, not the
# host's, so the launcher creates /run/tool-broker for the mount.
function project_forgejo_socket
    set -l remote (git -C $PWD remote get-url origin 2>/dev/null)
    or return
    # ssh://git@host:2222/owner/repo.git, git@host:owner/repo.git, https://…
    set -l repo (string replace -r '^.*[/:]' '' -- $remote | string replace -r '\.git$' '')
    set -l socket $HOME/.local/run/toolsocks/$repo.sock
    # no socket means no capability: the CLI says so instead of guessing
    test -S $socket
    or return
    echo $socket
end

# what claude loads as code or instructions from ~/.claude is mounted
# read-only (created inert when missing): settings.json carries hooks that run
# host commands on the next host-side claude run, CLAUDE.md is global memory
# injected into every session (persistent prompt injection), agents/ and
# commands/ define user-level agents and slash commands. The rest —
# transcripts/state — stays writable. ~/.claude.json must stay writable for
# claude's own state and can carry mcpServers — a known residual channel, like
# pie's writable ~/.pi. Project-level .claude/settings.json in $cwd is executed
# on host runs too — accepted, the project itself is writable.
function claude
    mkdir -p ~/.claude/agents ~/.claude/commands
    test -e ~/.claude/settings.json; or echo '{}' >~/.claude/settings.json
    touch ~/.claude/CLAUDE.md
    sandbox \
        --ro-bind-try ~/.local/share/claude ~/.local/share/claude \
        --bind ~/.claude ~/.claude \
        --ro-bind ~/.claude/settings.json ~/.claude/settings.json \
        --ro-bind ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md \
        --ro-bind ~/.claude/agents ~/.claude/agents \
        --ro-bind ~/.claude/commands ~/.claude/commands \
        --bind-try ~/.claude.json ~/.claude.json \
        claude --permission-mode auto $argv
end

# shadows the real binary so every pi run goes sandboxed; the log file and
# bind args are only created on demand, not at shell startup (piu bypasses via `command pi`)
function pi
    # must exist on the host before bwrap binds it; transcripts are private.
    # umask covers creation so there is no 644 window between touch and chmod
    set -l umask_saved (umask)
    umask 077
    touch /tmp/pi-subagents.log 2>/dev/null
    chmod 600 /tmp/pi-subagents.log 2>/dev/null
    # the agent dir stays writable because pi needs sessions/, the model cache and
    # proper-lockfile's *.lock dirs there, but every path pi loads as code, config
    # or system prompt is mounted read-only — otherwise anything running in the
    # sandbox could plant an extension that executes on the next host run. So each
    # guarded path must exist on the host first: --ro-bind-try would skip a
    # missing one and leave it plantable through the writable bind. models.json
    # redirects provider requests (auth headers follow), bin/ holds binaries pi
    # executes, APPEND_SYSTEM.md injects the system prompt — all guarded even
    # while unused; the seeds are inert: pi's models.json schema requires a
    # `providers` object, so the seed is the minimal valid file (no overrides);
    # settings.json is seeded too because its --ro-bind below is hard
    mkdir -p ~/.pi/agent/bin
    test -e ~/.pi/agent/settings.json; or echo '{}' >~/.pi/agent/settings.json
    test -e ~/.pi/agent/models.json; or echo '{"providers": {}}' >~/.pi/agent/models.json
    test -e ~/.pi/agent/APPEND_SYSTEM.md; or touch ~/.pi/agent/APPEND_SYSTEM.md
    umask $umask_saved
    set -l pi_binds \
        --bind-try /tmp/pi-subagents.log /tmp/pi-subagents.log \
        --bind ~/.pi/agent ~/.pi/agent \
        --ro-bind ~/.pi/agent/settings.json ~/.pi/agent/settings.json \
        --ro-bind ~/.pi/agent/models.json ~/.pi/agent/models.json \
        --ro-bind ~/.pi/agent/extensions ~/.pi/agent/extensions \
        --ro-bind ~/.pi/agent/skills ~/.pi/agent/skills \
        --ro-bind ~/.pi/agent/prompts ~/.pi/agent/prompts \
        --ro-bind ~/.pi/agent/themes ~/.pi/agent/themes \
        --ro-bind ~/.pi/agent/bin ~/.pi/agent/bin \
        --ro-bind ~/.pi/agent/AGENTS.md ~/.pi/agent/AGENTS.md \
        --ro-bind ~/.pi/agent/SYSTEM.md ~/.pi/agent/SYSTEM.md \
        --ro-bind ~/.pi/agent/APPEND_SYSTEM.md ~/.pi/agent/APPEND_SYSTEM.md \
        --ro-bind ~/.pi/agent/guard.list ~/.pi/agent/guard.list \
        --ro-bind ~/.pi/agent/auth.json ~/.pi/agent/auth.json
    # pi agent knobs, read by its extensions at load (auto.ts, guard.ts):
    # PI_AUTO starts pi in auto mode, PI_GUARDS=block enforces guard.list
    sandbox $pi_binds \
        --setenv PI_AUTO true \
        --setenv PI_GUARDS block \
        pi $argv
end

# pi for working on pi itself: cd into ~/.pi and run this. The whole tree is
# bound writable so extensions and config can be edited and tested in place;
# only auth.json (keys) and the guard list stay read-only.
function pie
    # sandbox() refuses home subtrees; ~/.pi is the one sanctioned exception —
    # export only after the cwd check passed and unset right after the call
    if test "$PWD" != "$HOME/.pi"; and not string match -q -- "$HOME/.pi/*" "$PWD"
        echo "pie: cd into ~/.pi first" >&2
        return 1
    end
    set -gx SANDBOX_ALLOW $HOME/.pi
    set -l umask_saved (umask)
    umask 077
    touch /tmp/pi-subagents.log 2>/dev/null
    chmod 600 /tmp/pi-subagents.log 2>/dev/null
    umask $umask_saved
    sandbox \
        --bind-try /tmp/pi-subagents.log /tmp/pi-subagents.log \
        --bind ~/.pi ~/.pi \
        --ro-bind-try ~/.pi/agent/auth.json ~/.pi/agent/auth.json \
        --ro-bind-try ~/.pi/agent/guard.list ~/.pi/agent/guard.list \
        --setenv PI_AUTO true \
        --setenv PI_GUARDS block \
        pi $argv
    set -e SANDBOX_ALLOW
end
abbr pic 'pi -c'
abbr piu 'command pi update'
