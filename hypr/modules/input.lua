---------------
---- INPUT ----
---------------

hl.config({
  input = {
    kb_layout    = "us,de,ru",
    kb_variant   = "",
    kb_model     = "",
    kb_options   = "caps:escape, grp:win_space_toggle, compose:ralt",
    kb_rules     = "",

    follow_mouse = 0,

    sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.

    touchpad     = {
      tap_to_click   = false,
      natural_scroll = false,
    },
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
  name        = "epic-mouse-v1",
  sensitivity = -0.5,
})
