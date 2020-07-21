#!/usr/bin/env sh

# variables
alacritty="$HOME/.config/alacritty/alacritty.yml"
fish="$HOME/.config/fish/conf.d/conf.fish"
kakrc="$HOME/.config/kak/kakrc"
nvim="$HOME/.config/nvim/init.vim"
gitconfig="$HOME/.gitconfig"
roficonfig="$HOME/.config/rofi/config"

# remove old links
for var in $alacritty $fish $kakrc $nvim $gitconfig $roficonfig
do
    rm $var
done

# create links
ln -s $HOME/dotfiles/alacritty/alacritty.yml $alacritty
ln -s $HOME/dotfiles/fish/conf.fish $fish
ln -s $HOME/dotfiles/kak/kakrc $kakrc
ln -s $HOME/dotfiles/nvim/init.vim $nvim
ln -s $HOME/dotfiles/.gitconfig $gitconfig
ln -s $HOME/dotfiles/rofi/config $roficonfig

