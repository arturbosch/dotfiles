#!/usr/bin/env fish

# Scale fuzzel dimensions relative to focused monitor resolution

# Base values at 1920px width
set BASE_WIDTH 1920
set FONT_SIZE 10
set LINE_HEIGHT 16

# Get focused monitor
set monitor (hyprctl monitors -j | jq -r '.[] | select(.focused == true)')
set width (echo $monitor | jq '.width')
set height (echo $monitor | jq '.height')
set scale (echo $monitor | jq '.scale')

# Effective resolution after scaling
set eff_w (math --scale 0 "$width / $scale")
set eff_h (math --scale 0 "$height / $scale")

# Margins - tighter for 4K to keep launcher compact
set x_margin (math --scale 0 "$eff_w * 35 / 100")   # 35% from each side
set y_margin (math --scale 0 "$eff_h * 30 / 100")   # 30% from top/bottom

# Font size: scale relative to base width
set font_size (math --scale 0 "$eff_w * $FONT_SIZE / $BASE_WIDTH")
if test $font_size -lt $FONT_SIZE
    set font_size $FONT_SIZE
end

set line_height (math --scale 0 "$eff_w * $LINE_HEIGHT / $BASE_WIDTH")
if test $line_height -lt $LINE_HEIGHT
    set line_height $LINE_HEIGHT
end

exec fuzzel \
  --dpi-aware=yes \
  --x-margin="$x_margin" \
  --y-margin="$y_margin" \
  --font="Adwaita Sans:size=$font_size" \
  --line-height="$line_height" \
  $argv
