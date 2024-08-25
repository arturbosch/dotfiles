#!/usr/bin/env sh

dotfiles=$HOME/dotfiles
confdir=$HOME/.config

# mkdirs

for dir in $confdir/fish/conf.d \
            $HOME/bin \
            $HOME/git/repos \
            $HOME/git/test \
            $HOME/git/system \
            $confdir/foot \
            $confdir/helix
do
    mkdir -p $dir
done

# create links

ln -sf $dotfiles/fish/conf.fish $confdir/fish/conf.d/conf.fish
ln -sf $dotfiles/fish/hhu.fish $confdir/fish/conf.d/hhu.fish
ln -sf $dotfiles/fish/fish_plugins $confdir/fish/fish_plugins
ln -sf $dotfiles/foot/foot.ini $confdir/foot/foot.ini
ln -sf $dotfiles/helix/config.toml $confdir/helix/config.toml
ln -sf $dotfiles/helix/languages.toml $confdir/helix/languages.toml
ln -sf $dotfiles/.gitconfig $HOME/.gitconfig
ln -sf $dotfiles/.gitignore $HOME/.gitignore
ln -sf $dotfiles/.npmrc $HOME/.npmrc
ln -sf $dotfiles/ags $confdir/ags
ln -sf $dotfiles/hypr $confdir/hypr

if [ ! -d $bashrcd ]
then
    ln -sf $dotfiles/.bashrc.d $bashrcd
fi
