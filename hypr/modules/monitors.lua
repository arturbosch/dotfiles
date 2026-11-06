------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- hl.monitor({
--   output   = "",
--   mode     = "preferred",
--   position = "auto",
--   scale    = "auto",
--   mirror   = "eDP-1",
-- })

local internal = {
  output = "eDP-1",
  mode = "preferred",
  position = "auto",
  scale = 1,
}

local office = {
  output   = "desc:Dell Inc. DELL U2518D 3C4YP89TA5PL",
  mode     = "preferred",
  position = "0x0",
  scale    = 1,
}

local home = {
  output   = "desc:Dell Inc. DELL U2725QE 5VRC734",
  mode     = "3840x2160@120",
  position = "auto",
  scale    = 1.5,
}

hl.monitor(internal)
hl.monitor(office)
hl.monitor(home)

local knownExternals = { string.sub(office.output, 6), string.sub(home.output, 6) }
local function isExternal(monitor)
  for _, known in ipairs(knownExternals) do
    if monitor.description == known then
      return true
    end
  end
  return false
end

local function hasExternal()
  local homeDocked = hl.get_monitor(home.output) ~= nil
  local officeDocked = hl.get_monitor(office.output) ~= nil
  return homeDocked or officeDocked
end

local function hasInternal()
  return hl.get_monitor(internal.output) ~= nil
end

local function setCursorSize(size)
  local value = tostring(size)
  hl.env("HYPRCURSOR_SIZE", value)
  hl.exec_cmd("hyprctl setcursor Adwaita " .. value)
end

local debounceTimer = nil

local function debounced(func, timeout)
  if debounceTimer then
    debounceTimer:set_enabled(false)
  end

  debounceTimer = hl.timer(function()
    func()
    debounceTimer = nil
  end, { timeout = timeout or 1000, type = "oneshot" })
end

local function handleDocking()
  debounced(function()
    local docked = hasExternal()
    local internalEnabled = hasInternal()

    if docked and internalEnabled then
      hl.notification.create({ text = "docked", timeout = 15000, icon = "ok" })
      hl.monitor({ output = internal.output, disabled = true })
    elseif not docked and not internalEnabled then
      hl.notification.create({ text = "undocked", timeout = 15000, icon = "ok" })
      -- Must pass disabled explicitly: hl.monitor merges into the existing rule,
      -- which still carries disabled = true from the docked branch.
      hl.monitor({ output = internal.output, disabled = false })
    end

    setCursorSize(docked and 30 or 15)
  end, 1000)
end

-- Register events
hl.on("hyprland.start", handleDocking)

hl.on("monitor.added", function(monitor)
  if isExternal(monitor) then
    handleDocking()
  end
end)

hl.on("monitor.removed", function(monitor)
  if isExternal(monitor) then
    handleDocking()
  end
end)

hl.on("config.reloaded", handleDocking)

-- Manual docking check
hl.bind("SUPER + SHIFT + Z", handleDocking)

-- Manual internal monitor toggle
local function ToggleLaptopMonitor()
  if hasInternal() then
    hl.monitor({ output = internal.output, disabled = true })
  else
    hl.monitor({ output = internal.output, disabled = false })
  end
end

hl.bind("SUPER + SHIFT + I", ToggleLaptopMonitor)
