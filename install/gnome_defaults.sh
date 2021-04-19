#!/bin/env sh

gsettings set org.gnome.desktop.peripherals.touchpad click-method areas
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"

# workspaces
gsettings set org.gnome.desktop.wm.preferences num-workspaces 10
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 '["<Super>1"]'
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 '["<Super>2"]'
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 '["<Super>3"]'
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 '["<Super>4"]'
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 '["<Super>5"]'
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 '["<Super>6"]'
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 '["<Super>7"]'
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 '["<Super>8"]'
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 '["<Super>9"]'
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 '["<Super>0"]'

# key bindings backup: gsettings list-recursively org.gnome.desktop.wm.keybindings
gsettings set org.gnome.desktop.wm.keybindings close ['<Shift><Super>q']
