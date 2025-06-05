#!/bin/env bash
sudo dnf copr enable solopasha/hyprland
sudo dnf install hyprland hyprpaper hyprlock fish foot wlogout wdisplays polkit-gnome aylurs-gtk-shell
# Choose either wlr or hyprland portal.
# As of 2024-08-11 wlr works more reliable for Intel cpu's.
# Also see portals.sh.
sudo dnf install xdg-desktop-portal-wlr
sudo dnf remove xdg-desktop-portal-hyprland
