# sandbox via bubblewrap
# caller mounts are plain bwrap flags appended after the fixed ones; bwrap stops
# parsing options at the command, so `sandbox --bind-try /a /a cmd` just works
function sandbox
    set -l cwd (pwd)

    # --bind $cwd is what makes the project writable; an ancestor of $HOME would
    # expose the whole home (or with / the whole filesystem) instead
    if test "$cwd" = /; or test "$cwd" = "$HOME"; or string match -q -- "$cwd/*" "$HOME"
        echo "sandbox: refusing to bind $cwd writable, cd into the project first" >&2
        return 1
    end

    # wayland: expose only the display socket (wl-copy/wl-paste), skipped if none
    set -l wayland_args
    if test -n "$WAYLAND_DISPLAY"; and test -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"
        set wayland_args --ro-bind "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"
    end

    # ssh agent: its socket lives in a host runtime dir that is not otherwise
    # bound, and there may be no agent at all — skip the group when there is none
    set -l ssh_args
    if set -q SSH_AUTH_SOCK; and test -S "$SSH_AUTH_SOCK"
        set -l ssh_dir (dirname $SSH_AUTH_SOCK)
        set ssh_args --ro-bind $ssh_dir $ssh_dir --setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
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

    # ensure cache dirs exist on the host before binding (mkdir -p is idempotent)
    mkdir -p ~/.cache/fontconfig ~/.cache/mesa_shader_cache

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
        # system (read-only)
        --ro-bind /usr /usr \
        --ro-bind /bin /bin \
        --ro-bind /lib /lib \
        --ro-bind /lib64 /lib64 \
        --ro-bind /etc /etc \
        --ro-bind /var/lib /var/lib \
        --ro-bind /var/log /var/log \
        --tmpfs /var/tmp \
        # user bins/libs (read-only)
        --ro-bind ~/.local/bin ~/.local/bin \
        --ro-bind ~/.local/lib ~/.local/lib \
        --ro-bind ~/.sdkman ~/.sdkman \
        # sharing dir
        --bind ~/share ~/share \
        # project & tool caches (writable)
        --bind $cwd $cwd \
        --bind-try ~/.gradle ~/.gradle \
        --bind-try ~/.mvn ~/.mvn \
        ## dotfiles is always okay as reference
        --ro-bind ~/dotfiles ~/dotfiles \
        # ephemeral (tmpfs)
        --tmpfs ~/.config \
        --tmpfs ~/.local/share \
        --tmpfs ~/.local/state \
        --tmpfs ~/.cache \
        # persistent caches: font scan + shader compile cost seconds, reuse across sessions
        --bind ~/.cache/fontconfig ~/.cache/fontconfig \
        # system cachedir (listed first in /etc/fonts): fc writes here first — must be persistent or writes die with the namespace
        --bind ~/.cache/fontconfig /var/cache/fontconfig \
        --bind ~/.cache/mesa_shader_cache ~/.cache/mesa_shader_cache \
        --tmpfs /tmp \
        # DNS (target of the /etc/resolv.conf symlink on Fedora)
        --ro-bind-try /run/systemd/resolve /run/systemd/resolve \
        # devices: only a minimal devtmpfs (includes pts, so ptys work) plus the
        # GPU nodes — binding all of /dev would hand out /dev/uinput (synthetic
        # input into the host session), hidraw, gpiochip, kvm
        --dev /dev \
        --ro-bind-try /dev/dri /dev/dri \
        # process info
        --proc /proc \
        # sysfs: Mesa device detection — without it kitty falls back to software rendering (llvmpipe)
        --ro-bind /sys /sys \
        # environment
        --setenv PATH (string join : $PATH) \
        --setenv HOME "$HOME" \
        --setenv USER "$USER" \
        --setenv PI_AUTO true \
        --setenv PI_GUARDS block \
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

set -g sandbox_claude_binds \
    --ro-bind-try ~/.local/share/claude ~/.local/share/claude \
    --bind-try ~/.claude ~/.claude \
    --bind-try ~/.claude.json ~/.claude.json

abbr claude 'sandbox $sandbox_claude_binds claude --permission-mode auto'

# shadows the real binary so every pi run goes sandboxed; the log file and
# bind args are only created on demand, not at shell startup (piu bypasses via `command pi`)
function pi
    # must exist on the host before bwrap binds it; transcripts are private
    touch /tmp/pi-subagents.log 2>/dev/null
    chmod 600 /tmp/pi-subagents.log 2>/dev/null
    # the agent dir stays writable because pi needs sessions/, the model cache and
    # proper-lockfile's *.lock dirs there, but every path pi loads as code, config
    # or system prompt is mounted read-only — otherwise anything running in the
    # sandbox could plant an extension that executes on the next host run
    set -l pi_binds \
        --bind-try /tmp/pi-subagents.log /tmp/pi-subagents.log \
        --bind-try ~/.pi/agent ~/.pi/agent \
        --ro-bind-try ~/.pi/agent/settings.json ~/.pi/agent/settings.json \
        --ro-bind-try ~/.pi/agent/models.json ~/.pi/agent/models.json \
        --ro-bind-try ~/.pi/agent/extensions ~/.pi/agent/extensions \
        --ro-bind-try ~/.pi/agent/skills ~/.pi/agent/skills \
        --ro-bind-try ~/.pi/agent/prompts ~/.pi/agent/prompts \
        --ro-bind-try ~/.pi/agent/themes ~/.pi/agent/themes \
        --ro-bind-try ~/.pi/agent/bin ~/.pi/agent/bin \
        --ro-bind-try ~/.pi/agent/AGENTS.md ~/.pi/agent/AGENTS.md \
        --ro-bind-try ~/.pi/agent/SYSTEM.md ~/.pi/agent/SYSTEM.md \
        --ro-bind-try ~/.pi/agent/APPEND_SYSTEM.md ~/.pi/agent/APPEND_SYSTEM.md \
        --ro-bind-try ~/.pi/agent/guard.list ~/.pi/agent/guard.list \
        --ro-bind-try ~/.pi/agent/auth.json ~/.pi/agent/auth.json
    sandbox $pi_binds pi $argv
end

# pi for working on pi itself: cd into ~/.pi and run this. The whole tree is
# bound writable so extensions and config can be edited and tested in place;
# only auth.json (keys) and the guard list stay read-only.
function pie
    if test "$PWD" != "$HOME/.pi"; and not string match -q -- "$HOME/.pi/*" "$PWD"
        echo "pie: cd into ~/.pi first" >&2
        return 1
    end
    touch /tmp/pi-subagents.log 2>/dev/null
    chmod 600 /tmp/pi-subagents.log 2>/dev/null
    sandbox \
        --bind-try /tmp/pi-subagents.log /tmp/pi-subagents.log \
        --bind ~/.pi ~/.pi \
        --ro-bind-try ~/.pi/agent/auth.json ~/.pi/agent/auth.json \
        --ro-bind-try ~/.pi/agent/guard.list ~/.pi/agent/guard.list \
        pi $argv
end
abbr pic 'pi -c'
abbr piu 'command pi update'
