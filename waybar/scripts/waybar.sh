#!/usr/bin/env sh

killall -e waybar
waybar 2>&1 > /tmp/waybar.txt &
