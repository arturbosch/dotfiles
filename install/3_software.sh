#!/usr/bin/env sh

## install command and additional software
if (uname -a | grep -q ubuntu)
then
    system="ubuntu"
    install="sudo apt install"
    additional_software="snapd printer-driver-gutenprint scrot thunar tldr-py neovim-qt"
else
    system="manjaro"
    install="sudo pamac install"
    additional_software="alacritty tlpui go vlc brave-beta firefox ttf-jetbrains-mono pcmanfm-qt"
    sudo pamac remove palemoon-bin
fi

## install common software
### archived: jekyll autojump
system_tools="htop powertop tlp curl wget zip unzip git fish fzf tig meld tk tcl tldr asciinema"
office_tools="thunderbird gimp virtualbox"
dev_tools="neovim kakoune hugo rust cargo nodejs yarn ruby"

$install $system_tools
$install $office_tools
$install $dev_tools

## install additional software
$install $additional_software

# fish plugin manager
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
sudo chsh $USER -s /usr/bin/fish

if [ "$system" = "ubuntu" ]
then
    sudo add-apt-repository ppa:mmstick76/alacritty
    sudo apt install alacritty

    # snaps
    sudo snap install go --classic
    sudo snap install vlc
fi

# go and rust tools
go get github.com/gokcehan/lf
cargo install dutree ytop hyperfine sd ripgrep fd-find exa skim
