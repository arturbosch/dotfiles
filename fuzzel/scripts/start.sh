#!/bin/bash
# Scale fuzzel dimensions relative to focused monitor resolution

# Base values at 1920px width
BASE_WIDTH=1920
FONT_SIZE=10
LINE_HEIGHT=16

monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)')
width=$(echo "$monitor" | jq '.width')
height=$(echo "$monitor" | jq '.height')
scale=$(echo "$monitor" | jq '.scale')

# Effective resolution after scaling
eff_w=$((width / ${scale%.*}))
eff_h=$((height / ${scale%.*}))

# Relative sizing (adjust percentages as needed)
x_margin=$((eff_w * 30 / 100))   # 30% of width from each side
y_margin=$((eff_h * 25 / 100))   # 25% from top/bottom

# Font size: scale relative to base width
font_size=$((eff_w * FONT_SIZE / BASE_WIDTH))
[ "$font_size" -lt "$FONT_SIZE" ] && font_size=$FONT_SIZE
line_height=$((eff_w * LINE_HEIGHT / BASE_WIDTH))
[ "$line_height" -lt "$LINE_HEIGHT" ] && line_height=$LINE_HEIGHT

exec fuzzel \
  --dpi-aware=yes \
  --x-margin="$x_margin" \
  --y-margin="$y_margin" \
  --font="Adwaita Sans:size=$font_size" \
  --line-height="$line_height" \
  "$@"
