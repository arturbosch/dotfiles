#!/bin/env sh
# copy home backup and update os
sudo apt update && sudo apt upgrade -y

# map capslock to escape
setxkbmap -option caps:escape
# enable middle and right click for touchpad
gsettings set org.gnome.desktop.peripherals.touchpad click-method areas

sudo ln -s "$HOME/dotfiles/startup.sh" /etc/init.d/startup.sh

