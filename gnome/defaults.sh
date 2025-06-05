#!/bin/env sh
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.peripherals.touchpad click-method areas
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
gsettings set org.gnome.desktop.notifications show-banners false

# disable favorite applications hotkeys
gsettings set org.gnome.shell.keybindings switch-to-application-1 []
gsettings set org.gnome.shell.keybindings switch-to-application-2 []
gsettings set org.gnome.shell.keybindings switch-to-application-3 []
gsettings set org.gnome.shell.keybindings switch-to-application-4 []
gsettings set org.gnome.shell.keybindings switch-to-application-5 []
gsettings set org.gnome.shell.keybindings switch-to-application-6 []
gsettings set org.gnome.shell.keybindings switch-to-application-7 []
gsettings set org.gnome.shell.keybindings switch-to-application-8 []
gsettings set org.gnome.shell.keybindings switch-to-application-9 []

# workspaces
gsettings set org.gnome.mutter dynamic-workspaces false
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
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 '["<Super><Shift>1"]'
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 '["<Super><Shift>2"]'
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 '["<Super><Shift>3"]'
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 '["<Super><Shift>4"]'
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 '["<Super><Shift>5"]'
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 '["<Super><Shift>6"]'
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 '["<Super><Shift>7"]'
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 '["<Super><Shift>8"]'
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9 '["<Super><Shift>9"]'
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 '["<Super><Shift>0"]'

# key bindings backup: gsettings list-recursively org.gnome.desktop.wm.keybindings
gsettings set org.gnome.desktop.wm.keybindings close '["<Shift><Super>q"]'

# paperwm
dconf write /org/gnome/shell/extensions/paperwm/show-workspace-indicator false
dconf write /org/gnome/shell/extensions/paperwm/show-focus-mode-icon true
dconf write /org/gnome/shell/extensions/paperwm/disable-topbar-styling true

# pop-shell

KEYS_POP=/org/gnome/shell/extensions/pop-shell
KEYS_GNOME_WM=/org/gnome/desktop/wm/keybindings

# Toggle maximization state
dconf write ${KEYS_GNOME_WM}/toggle-maximized "['<Super>f']"
# Toggle stacking windows
dconf write ${KEYS_POP}/toggle-stacking "['<Super>s']"
# Toggle floating window
dconf write ${KEYS_POP}/toggle-floating "['<Shift><Super>f']"

# Enter/Exit tile adjustment mode
dconf write ${KEYS_POP}/tile-enter "['<Super>r']"
dconf write ${KEYS_POP}/tile-accept "['Return']"
dconf write ${KEYS_POP}/tile-reject "['Escape']"
