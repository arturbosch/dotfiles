# Remove help message
function fish_greeting
end

function mark_prompt_start --on-event fish_prompt
    echo -en "\e]133;A\e\\"
end

# 4.1: alt-backspace changed from word deletion, restore it.
bind alt-backspace backward-kill-word

# gnome: map caps to escape key
if test "$XDG_SESSION_TYPE" = x11
    setxkbmap -option caps:escape
end

# Paths
set -Ux XDG_CONFIG_HOME $HOME/.config
set -Ux JAVA_HOME $HOME/.sdkman/candidates/java/current
set -Ux GRADLE_HOME $HOME/.sdkman/candidates/gradle/current

set PATH \
    $JAVA_HOME/bin \
    $GRADLE_HOME/bin \
    $HOME/bin \
    $HOME/dotfiles/bin \
    $HOME/dotfiles/ags/scripts \
    $HOME/.local/bin \
    $HOME/go/bin \
    $HOME/.cargo/bin \
    $HOME/.nimble/bin \
    $PATH

# Vars
set -Ux TERM foot
set -Ux LANG en_US.UTF-8
set -Ux EDITOR hx
set -Ux VISUAL hx
set -Ux SCROLLER hx
set -Ux PAGER cat
set -Ux BROWSER brave-browser

## Electron App Font Scaling
set -Ux ELECTRON_OZONE_PLATFORM_HINT wayland

## Java Swing on Wayland
set -Ux _JAVA_AWT_WM_NONREPARENTING 1
abbr idea _JAVA_AWT_WM_NONREPARENTING=1 idea

# Aliases && Abbreveations
abbr e $EDITOR

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
if test (head -1 /etc/os-release | grep -i 'openSUSE Tumbleweed')
    abbr inst "sudo zypper install"
    abbr up "sudo zypper up"
    abbr upa "sudo zypper up && flatpak update"
    abbr un "sudo zypper remove"
else if test (head -1 /etc/os-release | grep -i 'Fedora')
    abbr inst "sudo dnf install"
    abbr up "sudo dnf update"
    abbr upa "sudo dnf update && flatpak update"
    abbr un "sudo dnf remove"
else if test (head -1 /etc/os-release | grep -i 'Aeon')
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
abbr eh "$EDITOR $HOME/dotfiles/hypr/hyprland.conf"
abbr ehl "$EDITOR $HOME/dotfiles/hypr/hyprlock.conf"
abbr ehp "$EDITOR $HOME/dotfiles/hypr/hyprlpaper.conf"

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

# Functions

function dots
    set currentDir (pwd)
    cd ~/dotfiles
    ./dots $argv
    cd $currentDir
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
    cat /proc/$pid/status | grep -i vmrss | awk '{print $2/1000 " MB"}'
end

# git

## git add support via fzf
bind \cga git-add-fzf
bind -M insert \cga git-add-fzf
function git-add-fzf
    git add (git ls-files --modified --exclude-standard | fzf --ansi --no-sort --preview 'git diff --color=always -- {}')
end

bind \cb 'commandline -i (git rev-parse --abbrev-ref HEAD)'
