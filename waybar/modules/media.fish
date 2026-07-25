#!/usr/bin/env fish

set max_len 40
set state_file /tmp/waybar-media-player
set lock_file /tmp/waybar-media-lock

# --- Players ---
set players (playerctl -l 2>/dev/null)
if test (count $players) -eq 0
    exit 0
end

# --- Helpers ---
function find_idx --argument-names target
    set -l i 1
    for p in $players
        if test "$p" = "$target"
            echo $i
            return
        end
        set i (math $i + 1)
    end
    echo 1
end

function read_state
    if test -f $state_file
        cat $state_file
    else
        echo $players[1]
    end
end

# --- Switch player (called via scroll) ---
if test (count $argv) -gt 0
    set current (read_state)
    set idx (find_idx $current)
    set total (count $players)

    switch $argv[1]
        case next
            set idx (math "$idx % $total + 1")
        case prev
            set idx (math "($idx - 2 + $total) % $total + 1")
    end

    echo $players[$idx] > $state_file
    touch $lock_file
    exit 0
end

# --- Resolve current player ---
set current (read_state)
set current $players[(find_idx $current)]
echo $current > $state_file

# --- Auto-switch to playing player (unless locked) ---
if not test -f $lock_file
    for p in $players
        if test (playerctl status --player $p 2>/dev/null) = "Playing"
            if test "$p" != "$current"
                set current $p
                echo $current > $state_file
            end
            break
        end
    end
else
    # Clear lock if player is gone
    if test -z (playerctl status --player $current 2>/dev/null)
        rm -f $lock_file
    end
end

# --- Get metadata ---
set raw (playerctl metadata --player $current --format '{{status}}|{{title}} - {{artist}}|{{duration(position)}}|{{duration(mpris:length)}}' 2>/dev/null)

if test -z "$raw"
    # Fallback: find any active player
    for p in $players
        set s (playerctl status --player $p 2>/dev/null)
        if test "$s" = "Playing" -o "$s" = "Paused"
            set current $p
            echo $current > $state_file
            set raw (playerctl metadata --player $current --format '{{status}}|{{title}} - {{artist}}|{{duration(position)}}|{{duration(mpris:length)}}' 2>/dev/null)
            break
        end
    end
end

test -z "$raw"; and exit 0

# --- Parse metadata ---
set player_status (echo "$raw" | cut -d'|' -f1)
set info (echo "$raw" | cut -d'|' -f2)
set position (echo "$raw" | cut -d'|' -f3)
set length (echo "$raw" | cut -d'|' -f4)

switch "$player_status"
    case Playing; set icon "▶"
    case Paused; set icon "⏸"
    case '*'; exit 0
end

# --- Format ---
if test (string length -- "$info") -gt $max_len
    set text (string sub -l $max_len -- "$info")"..."
else
    set text "$info"
end

# Escape for JSON
set info (string replace -a '\\' '\\\\' -- "$info")
set info (string replace -a '"' '\\"' -- "$info")
set info (string replace -a '\n' '\\n' -- "$info")
set text (string replace -a '\\' '\\\\' -- "$text")
set text (string replace -a '"' '\\"' -- "$text")
set text (string replace -a '\n' '\\n' -- "$text")

test -n "$length" -a -n "$position" && set time "$position/$length" || set time ""

set arrows_left ""
set arrows_right ""
if test (count $players) -gt 1
    set arrows_left "‹ "
    set arrows_right " ›"
end

set class (string lower -- "$player_status")
set gray "#71717a"
echo "{\"text\":\"$arrows_left$icon $text <span foreground=\\\"$gray\\\">$time</span>$arrows_right\",\"tooltip\":\"$info\\nPlayer: $current\",\"class\":\"$class\",\"markup\":\"pango\"}"
