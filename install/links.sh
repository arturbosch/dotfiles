#!/usr/bin/env sh

dotfiles=$HOME/dotfiles
confdir=$HOME/.config

# mkdirs

for dir in $confdir/kak/plugins \
            $confdir/alacritty \
            $confdir/fish/conf.d \
            $HOME/bin \
            $HOME/dotfiles \
            $HOME/files \
            $HOME/git/repos \
            $HOME/git/test \
            $HOME/git/system \
            $HOME/scripts \
            $HOME/tools \
            $confdir/foot \
            $confdir/helix
do
    mkdir -p $dir
done

# create links

ln -sf $dotfiles/alacritty/alacritty.yml $confdir/alacritty/alacritty.yml
ln -sf $dotfiles/fish/conf.fish $confdir/fish/conf.d/conf.fish
ln -sf $dotfiles/fish/fish_plugins $confdir/fish/fish_plugins
ln -sf $dotfiles/foot/foot.ini $confdir/foot/foot.ini
ln -sf $dotfiles/helix/config.toml $confdir/helix/config.toml
ln -sf $dotfiles/kak/kakrc $confdir/kak/kakrc
ln -sf $dotfiles/.gitconfig $HOME/.gitconfig
ln -sf $dotfiles/.gitignore $HOME/.gitignore

if [ ! -d $bashrcd ]
then
    ln -sf $dotfiles/.bashrc.d $bashrcd
fi
