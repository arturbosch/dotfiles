#!/usr/bin/env bash
sleep 4
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-wlr
killall -e xdg-desktop-portal-gnome
killall xdg-desktop-portal
/usr/libexec/xdg-desktop-portal-wlr &
sleep 4
/usr/libexec/xdg-desktop-portal &
