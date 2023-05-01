function fish_greeting
end

function mark_prompt_start --on-event fish_prompt
    echo -en "\e]133;A\e\\"
end

# gnome: map caps to escape key
if test "$XDG_SESSION_TYPE" = "x11"
	setxkbmap -option caps:escape
end

# paths
set -Ux XDG_CONFIG_HOME $HOME/.config
set -Ux JAVA_HOME $HOME/.sdkman/candidates/java/current
set -Ux GRADLE_HOME $HOME/.sdkman/candidates/gradle/current
set -Ux JENKINS_HOME /var/lib/jenkins
set -Ux SSH_KEY_PTH $HOME/.ssh/rsa_id
set -Ux NODE_PATH $HOME/node_modules/
set -Ux GOPATH $HOME/go

## echo "gem: --user-install" >> ~/.gemrc
set -Ux GEM_HOME $HOME/.gem

## application paths
set PATH $JAVA_HOME/bin $GRADLE_HOME/bin $HOME/bin $HOME/.local/bin $HOME/.yarn/bin $HOME/go/bin $HOME/.cargo/bin $HOME/.nimble/bin $PATH

# vars
set -Ux TERM foot
set -Ux LANG en_US.UTF-8
set -Ux EDITOR hx
set -Ux ALT_EDITOR nvim
set -Ux VISUAL hx
set -Ux BROWSER brave-browser

## fix java gui apps on wayland
set -Ux _JAVA_AWT_WM_NONREPARENTING 1
abbr idea _JAVA_AWT_WM_NONREPARENTING=1 idea

## show app indicators in waybar
set -Ux XDG_CURRENT_DESKTOP Unity

# aliases && abbreveations
abbr e $EDITOR
abbr vim $ALT_EDITOR
abbr vi $ALT_EDITOR

## timewarrior shortcuts
abbr tw timew
abbr tws "timew sum"
abbr tww "timew week"
abbr twd "timew day"
abbr twm "timew month"

## config shortcuts
abbr ef "$EDITOR $HOME/dotfiles/fish/conf.fish"
abbr eq "$EDITOR $HOME/dotfiles/qtile/config.py"
abbr ei "$EDITOR $HOME/dotfiles/i3/config"
abbr ev "$ALT_EDITOR $HOME/dotfiles/nvim/init.vim"
abbr eg "$EDITOR $HOME/dotfiles/.gitconfig"
abbr ek "$EDITOR $HOME/dotfiles/kak/kakrc"

## other shortcuts
abbr gl tig
abbr bb "bluetoothctl"
abbr loc "tokei --sort=lines"
abbr md "mkdir -pv"
abbr rd "rm -R"
abbr nf "clear && neofetch"
abbr g "gradle"
abbr gw "./gradlew"
abbr gv "gradle -v"
abbr gdeps "gradle -q dependencies --configuration implementation"
abbr gb "gradle build"
abbr gcb "gradle clean build"
abbr gbp "gradle build publishToMavenLocal"
abbr gd "gradle detekt"
abbr f "cd ~/files && ls ~/files/ | dmenu -l 30"
abbr eff "$EDITOR (cd ~/.config/fish/functions && ls | dmenu -l 30)"
abbr ff "cat (cd ~/files && ls ~/files/ | dmenu -l 30)"
abbr fe "$EDITOR (cd ~/files && ls ~/files/ | dmenu -l 30)"
abbr j "java"
abbr jj "java -jar"
abbr jv "java -version"

### pi shortcuts
abbr piauth ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no -o PasswordAuthentication=yes pi

# installer
## apt
if test (uname -a | grep -i 'ubuntu')
    abbr inst "sudo apt install"
    abbr fp "sudo apt search"
    abbr up "sudo apt update && sudo apt upgrade"
    abbr upa "sudo apt update && sudo apt upgrade && sudo flatpak update && sdk upgrade"
## pacman
else if test (uname -a | grep -i 'manjaro')
    abbr inst "sudo pacman -S"
    abbr up "sudo yay"
    abbr p "sudo pacman"
    abbr pmi "sudo pacman -S"
    abbr pms "pacman -Ss"
    abbr pmr "sudo pacman -Rns"
    abbr pmu "sudo pacman -Syu"
    abbr pmq "pacman -Qe"
    abbr pmold "pacman -Qdt"
    abbr pmrold "sudo pacman -Sc"
    abbr fixpacman "rm /var/lib/pacman/db.lck"
else if test (uname -a | grep -i '.fc')
    abbr inst "sudo dnf install"
    abbr up "sudo dnf update"
    abbr upa "sudo dnf update && flatpak update && sdk upgrade"
    abbr uninst "sudo dnf remove"
    abbr unin "sudo dnf remove"
end

# aliases

## cat replacement
alias cat bat

## ls replacement
alias ls exa
alias ll "exa --long --git -h"
alias lt "exa --tree"

## flatpak
alias curtail "flatpak run com.github.huluti.Curtail"
alias nextc "flatpak run com.nextcloud.desktopclient.nextcloud"

## misc aliases
alias dl "youtube-dl -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0"
alias zip_git "zip -r git-with-excludes.zip git/ -x '**/node_modules/**' '**/build/**' '**/.idea/**' 'git/test/**' '**/target/**' '**/.gradle/**' '**/out/production/**' '**/out/test/**' '**/gbt_build/**'"

# additional functions

## shows weather
function weather
    set city Duisburg
    if test (count $argv) -eq 1
        set city $argv[1]
    end
    curl -4 http://wttr.in/$city
end

alias wetter weather

# git

## git add support via fzf
bind \cga git-add-fzf
bind -M insert \cga git-add-fzf
function git-add-fzf
    git add (git ls-files --modified --exclude-standard | fzf --ansi --no-sort --preview 'git diff --color=always -- {}')
end

