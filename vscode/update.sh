#!/bin/env sh

extfile=$HOME/dotfiles/vscode/extensions.txt
settingsfile=$HOME/dotfiles/vscode/settings.json

# copy user settings
cp $HOME/.var/app/com.vscodium.codium/config/VSCodium/User/settings.json $settingsfile

# generate extensions list
flatpak run com.vscodium.codium --list-extensions >> $extfile
sort -u -o $extfile $extfile
