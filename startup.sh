#!/usr/bin/env sh
tlp start
powertop --auto-tune
setxkbmap -option caps:escape
gsettings set org.gnome.desktop.peripherals.touchpad click-method areas

