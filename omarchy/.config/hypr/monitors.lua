-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- VGA CRT (left)
hl.monitor({ output = "DP-4", mode = "1024x768@60", position = "-1024x156", scale = 1 })

-- DisplayPort monitor, primary (middle)
hl.monitor({ output = "DP-1", mode = "preferred", position = "0x0", scale = 1 })

-- HDMI monitor (right)
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "1920x0", scale = 1 })

-- Fallback for any other/future monitor
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Make DisplayPort the primary monitor: cursor spawns here at startup,
-- and it's the fallback target for fullscreen/lock-screen/etc.
hl.config({
  cursor = {
    default_monitor = "DP-1",
  },
})

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
