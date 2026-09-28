# sandbox via bubblewrap
function sandbox
    set -l cwd (pwd)

    # parse --bind-extra and --ro-bind-extra flags from the front of argv
    set -l extra_binds
    set -l extra_ro_binds
    while true
        if test (count $argv) -ge 2; and test "$argv[1]" = --bind-extra
            set -a extra_binds $argv[2]
            set argv $argv[3..-1]
        else if test (count $argv) -ge 2; and test "$argv[1]" = --ro-bind-extra
            set -a extra_ro_binds $argv[2]
            set argv $argv[3..-1]
        else
            break
        end
    end

    set -l cmd (command -s $argv[1])
    set -l argv $cmd $argv[2..-1]

    # build extra bind args for bwrap; a spec is SRC or SRC:DEST, missing SRC is skipped
    set -l extra_bind_args
    for spec in $extra_binds
        set -l paths (string split -m 1 : $spec)
        set -a extra_bind_args --bind-try $paths[1] $paths[-1]
    end
    for spec in $extra_ro_binds
        set -l paths (string split -m 1 : $spec)
        set -a extra_bind_args --ro-bind-try $paths[1] $paths[-1]
    end

    # wayland: expose only the display socket (wl-copy/wl-paste), skipped if none
    set -l wayland_args
    if test -n "$WAYLAND_DISPLAY"; and test -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"
        set wayland_args --ro-bind "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"
    end

    # ensure cache dirs exist on the host before binding (mkdir -p is idempotent)
    mkdir -p ~/.cache/fontconfig ~/.cache/mesa_shader_cache

    echo "Entering sandbox for $cwd" >&2

    bwrap \
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
        --bind ~/.gradle ~/.gradle \
        --bind ~/.mvn ~/.mvn \
        ## dotfiles is always okay as reference
        --bind ~/dotfiles ~/dotfiles \
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
        ## config overlay
        # fish: rw because fish rewrites fish_variables via temp-file+rename (needs writable dir)
        --bind ~/.config/fish ~/.config/fish \
        --ro-bind ~/dotfiles/kitty ~/.config/kitty \
        --ro-bind ~/dotfiles/helix ~/.config/helix \
        # DNS (target of the /etc/resolv.conf symlink on Fedora)
        --ro-bind-try /run/systemd/resolve /run/systemd/resolve \
        # devices (spawned terminals need a pty)
        --dev-bind /dev /dev \
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
        --ro-bind "$(dirname $SSH_AUTH_SOCK)" "$(dirname $SSH_AUTH_SOCK)" \
        --ro-bind ~/.gitconfig ~/.gitconfig \
        --ro-bind ~/.ssh/known_hosts ~/.ssh/known_hosts \
        --ro-bind ~/.ssh/config ~/.ssh/config \
        --setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK" \
        #--tmpfs /etc/ssh/ssh_config.d \
        # wayland clipboard
        $wayland_args \
        # extra binds
        $extra_bind_args \
        # execution
        --chdir $cwd \
        $argv
end

set -g sandbox_claude_binds \
    --ro-bind-extra ~/.local/share/claude \
    --bind-extra ~/.claude \
    --bind-extra ~/.claude.json

abbr claude 'sandbox $sandbox_claude_binds command claude --permission-mode auto'

# shadows the real binary so every pi run goes sandboxed; the log file and
# bind args are only created on demand, not at shell startup (piu bypasses via `command pi`)
function pi
    # must exist on the host before bwrap binds it
    touch /tmp/pi-subagents.log 2>/dev/null
    sandbox \
        --bind-extra /tmp/pi-subagents.log:/tmp/pi-subagents.log \
        --bind-extra ~/.pi/agent \
        --ro-bind-extra ~/.pi/agent/auth.json \
        --ro-bind-extra ~/.pi/agent/guard.list \
        pi $argv
end
abbr pic 'pi -c'
abbr piu 'command pi update'
abbr qwen 'sandbox --bind-extra ~/.qwen qwen'
abbr mimo 'sandbox --bind-extra ~/.config/mimocode mimo'
