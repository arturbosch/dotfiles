-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
  hl.exec_cmd("/usr/libexec/polkit-gnome-authentication-agent-1") -- gnome authentication
  hl.exec_cmd("/usr/libexec/gsd-rfkill")                          -- gnome-settings-daemon for a working bluetooth section
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("mako")
  hl.exec_cmd("fcitx5 -d") -- input method pinyin
  -- TODO conditional on amount of monitors
  hl.exec_cmd("hyprctl setcursor Adwaita 15")
  -- TODO monitors script for now, rewrite to lua
  --hl.exec_cmd("$HOME/.config/hypr/scripts/monitors.fish")
  --hl.exec_cmd("$HOME/.config/hypr/scripts/portals.sh")
  hl.exec_cmd("$HOME/.config/waybar/scripts/waybar.sh")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'")       -- for GTK3 apps
  hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'") -- for GTK4 apps
end)

hl.on("hyprland.start", function()
  hl.exec_cmd("brave-browser", { workspace = "1" })
  hl.exec_cmd("kitty", { workspace = "3" })
  hl.exec_cmd("nautilus", { workspace = "4" })
  hl.exec_cmd("thunderbird", { workspace = "8" })
end)

hl.on("hyprland.shutdown", function()
end)
