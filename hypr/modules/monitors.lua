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

hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  position = "auto",
  scale = 1,
})

hl.monitor({
  output   = "desc:Dell Inc. DELL U2518D 3C4YP89TA5PL",
  mode     = "preferred",
  position = "0x0",
  scale    = 1,
})

hl.monitor({
  output   = "desc:Dell Inc. DELL U2725QE 5VRC734",
  mode     = "3840x2160@120",
  position = "auto",
  scale    = 1.5,
})
