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

# remove old links
for var in $alacritty $fish $kakrc $nvim $gitconfig $roficonfig $fish_plugins $qtileconfig $swayconfig $lfrc
do
    rm $var
done

# create links
ln -s $dotfiles/alacritty/alacritty.yml $alacritty
ln -s $dotfiles/fish/conf.fish $fish
ln -s $dotfiles/fish/fish_plugins $fish_plugins
ln -s $dotfiles/kak/kakrc $kakrc
ln -s $dotfiles/nvim/init.vim $nvim
ln -s $dotfiles/.gitconfig $gitconfig
ln -s $dotfiles/rofi/config $roficonfig
ln -s $dotfiles/qtile/config.py $qtileconfig
ln -s $dotfiles/sway/config $swayconfig
ln -s $dotfiles/lf/lfrc $lfrc
chmod +x $dotfiles/lf/previewer.sh

if [ ! -d $bashrcd ]
then
    ln -s $dotfiles/.bashrc.d $bashrcd
else
    echo "$bashrcd already present"
fi
