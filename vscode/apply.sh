#!/bin/env sh

extfile=$HOME/dotfiles/vscode/extensions.txt
settingsfile=$HOME/dotfiles/vscode/settings.json

 # copy user settings
cp $settingsfile $HOME/.var/app/com.vscodium.codium/config/VSCodium/User/settings.json

# install extensions
xargs -ra $extfile -I{} flatpak run com.vscodium.codium --install-extension {}

