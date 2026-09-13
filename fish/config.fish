# Remove help message
function fish_greeting
end

function mark_prompt_start --on-event fish_prompt
    echo -en "\e]133;A\e\\"
end

# fish 4.1: alt-backspace changed from word deletion, restore it.
bind alt-backspace backward-kill-word

# gnome: map caps to escape key
if test "$XDG_SESSION_TYPE" = x11
    setxkbmap -option caps:escape
end

# Paths
set -Ux XDG_CONFIG_HOME $HOME/.config
set -Ux JAVA_HOME $HOME/.sdkman/candidates/java/current
set -Ux GRADLE_HOME $HOME/.sdkman/candidates/gradle/current

fish_add_path \
    $JAVA_HOME/bin \
    $GRADLE_HOME/bin \
    $HOME/bin \
    $HOME/dotfiles/bin \
    $HOME/dotfiles/ags/scripts \
    $HOME/.local/bin \
    $HOME/go/bin \
    $HOME/.cargo/bin \
    $HOME/.nimble/bin

# Vars
set -gx TERM foot
set -Ux LANG en_US.UTF-8
set -Ux EDITOR hx
set -Ux VISUAL hx
set -Ux SCROLLER hx
set -gx PAGER bat
set -Ux BROWSER brave-browser

## Electron App Font Scaling
set -Ux ELECTRON_OZONE_PLATFORM_HINT wayland

## Java Swing on Wayland
set -Ux _JAVA_AWT_WM_NONREPARENTING 1
abbr idea _JAVA_AWT_WM_NONREPARENTING=1 idea

# Hydro prompt — sandstone path + prompt symbol; command text stays white
set -g hydro_color_pwd e6d5b8
set -g hydro_color_prompt e6d5b8
set -g hydro_color_duration 71717a

# Syntax colors (was the deleted conf.d/fish_frozen_theme.fish overriding these)
set -g fish_color_normal ffffff
set -g fish_color_command e6d5b8
set -g fish_color_param ffffff
set -g fish_color_autosuggestion a0947c

# Aliases && Abbreviations
abbr e $EDITOR
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

    # build extra bind args for bwrap
    set -l extra_bind_args
    for dir in $extra_binds
        set -a extra_bind_args --bind $dir $dir
    end
    for dir in $extra_ro_binds
        set -a extra_bind_args --ro-bind $dir $dir
    end

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
        --ro-bind ~/.sdkman/candidates ~/.sdkman/candidates \
        # sharing dir
        --bind ~/share ~/share \
        # project & tool caches (writable)
        --bind $cwd $cwd \
        --bind ~/.gradle ~/.gradle \
        --bind ~/.mvn ~/.mvn \
        $extra_bind_args \
        # config overlay (read-only)
        --ro-bind ~/.config/fish ~/.config/fish \
        # ephemeral (tmpfs)
        --tmpfs ~/.config \
        --tmpfs ~/.local/share \
        --tmpfs ~/.local/state \
        --tmpfs ~/.cache \
        --tmpfs /tmp \
        # devices
        --dev-bind /dev/null /dev/null \
        --dev-bind /dev/urandom /dev/urandom \
        # process info
        --proc /proc \
        # environment
        --setenv PATH (string join : $PATH) \
        --setenv PI_YOLO 1 \
        --setenv PI_BLOCK_FILES 1 \
        # execution
        --chdir $cwd \
        $argv
end

abbr pi 'sandbox --bind-extra ~/.pi/agent --ro-bind-extra ~/.pi/agent/auth.json --ro-bind-extra ~/.pi/agent/guard.list pi'
abbr pic 'sandbox --bind-extra ~/.pi/agent --ro-bind-extra ~/.pi/agent/auth.json --ro-bind-extra ~/.pi/agent/guard.list pi -c'
abbr piu 'command pi update'
abbr pig 'GONDOLIN_DEFAULT_IMAGE=dev:latest PI_YOLO=1 PI_BLOCK_FILES=1 command pi -c -e ~/.pi/gondolin'
abbr qwen 'sandbox --bind-extra ~/.qwen qwen'
abbr mimo 'sandbox --bind-extra ~/.config/mimocode mimo'

## cat replacement
if test -f /bin/bat
    alias cat bat
    abbr catp cat --decorations never
end

## ls replacement
if type -q eza
    alias exa eza
end
alias ls exa
alias ll "exa --long --git -h"
alias lt "exa --tree"

## Package Manager
if grep -qi 'opensuse tumbleweed' /etc/os-release
    abbr inst "sudo zypper install"
    abbr dup "sudo zypper dup"
    abbr up "sudo zypper up"
    abbr upa "sudo zypper up && flatpak update && rustup update stable"
    abbr un "sudo zypper remove"
else if grep -qi fedora /etc/os-release
    abbr inst "sudo dnf install"
    abbr up "sudo dnf update"
    abbr upa "sudo dnf update && flatpak update && rustup update stable"
    abbr un "sudo dnf remove"
else if grep -qi aeon /etc/os-release
    abbr inst "sudo transactional-update pkg install"
    abbr un "sudo transactional-update pkg remove"
end

## hyprland
abbr wallpaper hyprctl hyprpaper wallpaper ,~/Nextcloud/wallpapers/current

## timewarrior shortcuts
abbr tw timew
abbr tws "timew sum"
abbr tww "timew week"
abbr twd "timew day"
abbr twm "timew month"

## config shortcuts
abbr ef "$EDITOR $HOME/dotfiles/fish/config.fish"
abbr eg "$EDITOR $HOME/dotfiles/.gitconfig"
abbr eh "$EDITOR $HOME/dotfiles/hypr/hyprland.lua"
abbr ehl "$EDITOR $HOME/dotfiles/hypr/hyprlock.conf"
abbr ehp "$EDITOR $HOME/dotfiles/hypr/hyprpaper.conf"

## other shortcuts
abbr gl tig
abbr bb bluetui
abbr loc "tokei --sort=lines"
abbr md "mkdir -pv"
abbr rd "rm -R"
abbr g "gradle -q"
abbr gw "./gradlew -q"
abbr gv "gradle -v"
abbr gdeps "gradle -q dependencies --configuration implementation"
abbr gb "gradle build -q"
abbr gbw "gradle build --continuous -q"
abbr gcb "gradle clean build -q"
abbr gbp "gradle build publishToMavenLocal -q"
abbr gdu "gradle -q dU"
abbr gd "gradle detekt -q"
abbr j just
abbr jj "java -jar"
abbr jv "java -version"
abbr gsc XDG_CURRENT_DESKTOP=Gnome gnome-control-center
abbr logout "loginctl terminate-user $USER"
abbr codium flatpak run com.vscodium.codium

# Monitor
abbr ddcfull sudo ddcutil setvcp 10 100
abbr ddcwork sudo ddcutil setvcp 10 70
abbr ddcsleep sudo ddcutil setvcp 10 0
abbr ddcdimmed sudo ddcutil setvcp 10 20
abbr ddcevening sudo ddcutil setvcp 10 50

# Functions

function dots
    fish -c "cd ~/dotfiles && ./dots $argv"
end

## shows weather
function weather
    set city Duesseldorf
    if test (count $argv) -eq 1
        set city $argv[1]
    end
    curl -4 http://wttr.in/$city
end

alias wetter weather

## show memory usage
function vmrss
    set pid $argv[1]
    grep -i vmrss /proc/$pid/status | awk '{print $2/1000 " MB"}'
end

## fix audio
function reload_pipewire
    systemctl --user restart pipewire pipewire-pulse
    systemctl --user daemon-reload
    systemctl --user restart wireplumber
end

# git

## git add support via fzf
bind \cga git-add-fzf
bind -M insert \cga git-add-fzf
function git-add-fzf
    git add (git ls-files --modified --exclude-standard | fzf --ansi --no-sort --preview 'git diff --color=always -- {}')
end

bind \cb 'commandline -i (git rev-parse --abbrev-ref HEAD)'
