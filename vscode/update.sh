#!/bin/env sh

extfile=$HOME/dotfiles/vscode/extensions.txt
settingsfile=$HOME/dotfiles/vscode/settings.json

# copy user settings
cp $HOME/.config/VSCodium/User/settings.json $settingsfile

# generate extensions list
codium --list-extensions >> $extfile
sort -u -o $extfile $extfile
