#!/usr/bin/env sh

dotfiles="$HOME/dotfiles"

# mkdirs

mkdir -p $HOME/.config/lf
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.config/qtile
mkdir -p $HOME/.config/rofi
mkdir -p $HOME/.config/kak/plugins
mkdir -p $HOME/.config/alacritty
mkdir -p $HOME/.config/fish/conf.d
mkdir -p $HOME/.config/sway
mkdir -p $HOME/.config/waybar
mkdir -p $HOME/bin
mkdir -p $HOME/dotfiles
mkdir -p $HOME/files
mkdir -p $HOME/git/repos
mkdir -p $HOME/git/test
mkdir -p $HOME/git/system
mkdir -p $HOME/scripts
mkdir -p $HOME/tools

# variables
alacritty="$HOME/.config/alacritty/alacritty.yml"
fish="$HOME/.config/fish/conf.d/conf.fish"
fish_plugins="$HOME/.config/fish/fish_plugins"
kakrc="$HOME/.config/kak/kakrc"
nvim="$HOME/.config/nvim/init.vim"
gitconfig="$HOME/.gitconfig"
roficonfig="$HOME/.config/rofi/config"
qtileconfig="$HOME/.config/qtile/config.py"
bashrcd="$HOME/.bashrc.d"
swayconfig="$HOME/.config/sway/config"
lfrc="$HOME/.config/lf/lfrc"

# create links
ln -sf $dotfiles/alacritty/alacritty.yml $alacritty
ln -sf $dotfiles/fish/conf.fish $fish
ln -sf $dotfiles/fish/fish_plugins $fish_plugins
ln -sf $dotfiles/kak/kakrc $kakrc
ln -sf $dotfiles/nvim/init.vim $nvim
ln -sf $dotfiles/.gitconfig $gitconfig
ln -sf $dotfiles/rofi/config $roficonfig
ln -sf $dotfiles/qtile/config.py $qtileconfig
ln -sf $dotfiles/sway/config $swayconfig
ln -sf $dotfiles/waybar $HOME/.config
ln -sf $dotfiles/lf/lfrc $lfrc
chmod +x $dotfiles/lf/previewer.sh

if [ ! -d $bashrcd ]
then
    ln -sf $dotfiles/.bashrc.d $bashrcd
fi
