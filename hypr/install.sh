#!/bin/env bash
sudo dnf copr enable solopasha/hyprland
sudo dnf install hyprland hyprpaper hyprlock fish foot wlogout polkit-gnome aylurs-gtk-shell
sudo dnf remove xdg-desktop-portal-wlr
sudo dnf install xdg-desktop-portal-hyprland
