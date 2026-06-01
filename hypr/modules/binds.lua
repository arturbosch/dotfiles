---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal       = "kitty"
local menu           = "fuzzel"
local bar            = "$HOME/dotfiles/waybar/scripts/waybar.sh"
local barToggle      = "$HOME/dotfiles/waybar/scripts/waybar-hide.sh"
local logout         = "wlogout"
local bluetooth      = "kitty -e bluetui"
local wifi           = "kitty -e nmtui"
local processManager = "kitty -e htop"
local settings       = "XDG_CURRENT_DESKTOP=Gnome gnome-control-center"
local wmReload       = "hyprctl reload"
local printWindow    = "hyprshot -m window"
local printRegion    = "hyprshot -m region"
local printScreen    = "hyprshot -m output"

local flatpakRun     = "flatpak run "
---------------------
---- KEYBINDINGS ----
---------------------

local mainMod        = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

-- Open Programs
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(wifi))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(bluetooth))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd(processManager))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(settings))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd(logout))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(wmReload))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(flatpakRun .. "org.localsend.localsend_app"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(printScreen))
hl.bind("PRINT", hl.dsp.exec_cmd(printRegion))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd(printWindow))
hl.bind("CONTROL + SHIFT + PRINT", hl.dsp.exec_cmd(printScreen))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(printRegion))
hl.bind(mainMod .. " + CONTROL + SHIFT + P", hl.dsp.exec_cmd(printWindow))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(barToggle))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(bar))

hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + equal", hl.dsp.layout("colresize +conf"))
hl.bind(mainMod .. " + minus", hl.dsp.layout("colresize -conf"))
--hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
--hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only
--hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
local closeWindowBind = hl.bind(mainMod .. "+ SHIFT + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
