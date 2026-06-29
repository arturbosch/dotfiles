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
set -gx PAGER cat
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
alias pi 'command pi --tools read,bash,edit,write,grep,find,ls'

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
    abbr up "sudo zypper up"
    abbr upa "sudo zypper up && flatpak update && rustup update"
    abbr un "sudo zypper remove"
else if grep -qi 'fedora' /etc/os-release
    abbr inst "sudo dnf install"
    abbr up "sudo dnf update"
    abbr upa "sudo dnf update && flatpak update && rustup update"
    abbr un "sudo dnf remove"
else if grep -qi 'aeon' /etc/os-release
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
abbr ef "$EDITOR $HOME/dotfiles/fish/conf.fish"
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
