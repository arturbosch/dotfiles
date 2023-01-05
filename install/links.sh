#!/usr/bin/env sh

dotfiles=$HOME/dotfiles
confdir=$HOME/.config

# mkdirs

for dir in $confdir/kak/plugins \
            $confdir/alacritty \
            $confdir/fish/conf.d \
            $HOME/bin $HOME/dotfiles $HOME/files $HOME/git/repos $HOME/git/test $HOME/git/system $HOME/scripts $HOME/tools
do
    mkdir -p $dir
done

# variables
alacritty="$confdir/alacritty/alacritty.yml"
fish="$confdir/fish/conf.d/conf.fish"
fish_plugins="$confdir/fish/fish_plugins"
kakrc="$confdir/kak/kakrc"
nvim="$confdir/nvim/init.vim"
gitconfig="$HOME/.gitconfig"
roficonfig="$confdir/rofi/config"
qtileconfig="$confdir/qtile/config.py"
bashrcd="$HOME/.bashrc.d"
swayconfig="$confdir/sway/config"
lfrc="$confdir/lf/lfrc"

# create links
ln -sf $dotfiles/alacritty/alacritty.yml $alacritty
ln -sf $dotfiles/fish/conf.fish $fish
ln -sf $dotfiles/fish/fish_plugins $fish_plugins
ln -sf $dotfiles/kak/kakrc $kakrc
ln -sf $dotfiles/.gitconfig $gitconfig

if [ ! -d $bashrcd ]
then
    ln -sf $dotfiles/.bashrc.d $bashrcd
fi
