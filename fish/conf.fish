function fish_greeting
end

setxkbmap -option caps:escape

# paths
set -Ux XDG_CONFIG_HOME $HOME/.config
set -Ux JAVA_HOME $HOME/.sdkman/candidates/java/current
set -Ux JENKINS_HOME /var/lib/jenkins

## add application paths
set PATH $JAVA_HOME/bin $HOME/bin $HOME/.local/bin $HOME/.yarn/bin $HOME/.gem/ruby/2.7.0/bin $HOME/go/bin $HOME/.cargo/bin $HOME/.nimble/bin $PATH

set SSH_KEY_PTH $HOME/.ssh/rsa_id

# vars
set LANG en_US.UTF-8
set EDITOR kak
set VISUAL kak
set BROWSER brave

## fix java gui apps on wayland
set _JAVA_AWT_WM_NONREPARENTING 1
abbr idea _JAVA_AWT_WM_NONREPARENTING=1 idea

# aliases && abbreveations
abbr e $EDITOR
abbr vim nvim
abbr vi nvim

abbr tw timew
abbr tws "timew sum"
abbr tww "timew week"
abbr twd "timew day"
abbr twm "timew month"

## config shortcuts
abbr ef "$EDITOR $HOME/dotfiles/fish/conf.fish"
abbr eq "$EDITOR $HOME/dotfiles/qtile/config.py"
abbr ei "$EDITOR $HOME/dotfiles/i3/config"
abbr ev "nvim $HOME/dotfiles/nvim/init.vim"
abbr eg "$EDITOR $HOME/dotfiles/.gitconfig"
abbr ek "$EDITOR $HOME/dotfiles/kak/kakrc"

## other shortcuts
abbr gl tig
if test (uname -a | grep 'pop-os')
    alias fd fdfind
end
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

# installer
## apt
if test (uname -a | grep -i 'pop-os')
    abbr inst "sudo apt install"
    abbr fp "sudo apt search"
    abbr up "sudo apt update && sudo apt upgrade"
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
    abbr uninst "sudo dnf remove"
    abbr unin "sudo dnf remove"
end

# ls replacement
alias ls exa
alias ll "exa --long --git"
alias lt "exa --tree"

# flatpak
alias popsicle "flatpak run com.system76.Popsicle"
alias curtail "flatpak run com.github.huluti.Curtail"

# misc aliases
abbr dl "youtube-dl -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0"
alias jshell "$JAVA_HOME/bin/jshell"
alias mm "java -jar -Xmx50m ~/tools/mm.jar"
alias mmx "java -XX:TieredStopAtLevel=1 -XX:CICompilerCount=1 -XX:+UseSerialGC -Xshare:on -XX:-UsePerfData -Xmx20m -Xms20m -jar ~/tools/mm.jar"
alias gbt "java -jar -Xmx128m -Xms128m $HOME/tools/gbt-1.0.jar"
alias dgbt "sh $HOME/git/repos/gbt/build/distributions/gbt/bin/gbt"
# alias groovy groovyclient
alias zip_git "zip -r git-with-excludes.zip git/ -x '**/node_modules/**' '**/build/**' '**/.idea/**' 'git/test/**' '**/target/**' '**/.gradle/**' '**/out/production/**' '**/out/test/**' '**/gbt_build/**'"

# ruby
# echo "gem: --user-install" >> ~/.gemrc
set GEM_HOME $HOME/.gem

# js npm stuff
export NODE_PATH=$HOME/node_modules/

# go
set GOPATH $HOME/go

# additional functions

## shows weather
function weather
    set city Bremen
    if test (count $argv) -eq 1
        set city $argv[1]
    end
    curl -4 http://wttr.in/$city
end

alias wetter weather

## creates a playlist from files in current directory
function create_playlist
    set homeDir $HOME/Music/playlists
    set count (count $argv)
    echo $count
    if test $count = 0
        echo "Usage: [directory name] [playlist name] (playlist is stored in ($HOME/Music/playlists)"
    else if test $count = 1
        set plistName $argv[1]
        find (pwd -P) -maxdepth 1 -type f -iregex ".*\.\(aac\|flac\|mp3\|ogg\|wav\)\$" | sort > $homeDir/$plistName
    else
        echo "Usage: [directory name] [playlist name] (playlist is stored in ($HOME/Music/playlists)"
    end
end

## fzf git add support
bind \cga git-add-fzf
bind -M insert \cga git-add-fzf
function git-add-fzf
    git add (git ls-files --modified --exclude-standard | fzf --ansi --no-sort --preview 'git diff --color=always -- {}')
end

# starship init fish | source

