#!/bin/env sh

extfile=$HOME/dotfiles/vscode/extensions.txt
settingsfile=$HOME/dotfiles/vscode/settings.json

 # copy user settings
cp $settingsfile $HOME/.config/VSCodium/User/settings.json

# install extensions
xargs -ra $extfile -I{} codium --install-extension {}

