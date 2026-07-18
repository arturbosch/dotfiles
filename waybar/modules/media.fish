#!/usr/bin/env fish

set max_len 40

set raw (playerctl metadata --format '{{status}}|{{title}} - {{artist}}|{{duration(position)}}|{{duration(mpris:length)}}' 2>/dev/null)

if test -z "$raw"
    exit 0
end

set player_status (echo "$raw" | cut -d'|' -f1)
set info (echo "$raw" | cut -d'|' -f2)
set position (echo "$raw" | cut -d'|' -f3)
set length (echo "$raw" | cut -d'|' -f4)

# Icon
switch "$player_status"
    case Playing
        set icon "▶"
    case Paused
        set icon "⏸"
    case '*'
        exit 0
end

# Truncate text
if test (string length -- "$info") -gt $max_len
    set text (string sub -l $max_len -- "$info")"..."
else
    set text "$info"
end

# Time
if test -n "$length" -a -n "$position"
    set time "$position/$length"
else
    set time ""
end

set class (string lower -- "$player_status")
set gray "#71717a"
echo "{\"text\":\"$icon $text <span foreground=\\\"$gray\\\">$time</span>\",\"tooltip\":\"$info\",\"class\":\"$class\",\"markup\":\"pango\"}"
