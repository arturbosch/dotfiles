-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "15")
hl.env("HYPRCURSOR_SIZE", "15")
hl.env("HYPRCURSOR_THEME", "Adwaita")
hl.env("GTK_THEME", "adw-gt3:dark")
hl.env("QT_QPA_PLATFORMTHEME", "gtk4") -- qt6ct?
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
