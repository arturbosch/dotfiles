#!/usr/bin/env sh
sudo apt install htop powertop tlp snapd printer-driver-gutenprint \
    curl fish git fzf ripgrep tig meld tk tcl tldr tldr-py autojump \
    fd-find suckless-tools asciinema scrot \
    thunar geary \
    neovim neovim-qt kakoune \
    nodejs yarn hugo jekyll ruby cargo

# fish
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
sudo chsh artur -s /usr/bin/fish

# terminal emulator
sudo add-apt-repository ppa:mmstick76/alacritty
sudo apt install alacritty

# snaps
sudo snap install go --classic
sudo snap install vlc

# go get
go get github.com/gokcehan/lf
