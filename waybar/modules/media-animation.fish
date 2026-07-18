#!/usr/bin/env fish

set frames ▂▄▆ ▄▂▆ ▄▆▂ ▆▄▂ ▆▂▄
set frame_count (count $frames)
set i 1

while true
    set player_status (playerctl metadata --format '{{status}}' 2>/dev/null)

    if test "$player_status" = "Playing"
        echo $frames[$i]
        set i (math "$i % $frame_count + 1")
        sleep 0.1
    else if test "$player_status" = "Paused"
        echo " 󰏤 "
        sleep 1
    else
        echo ""
        sleep 1
    end
end
