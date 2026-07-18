#!/usr/bin/env fish

set max_len 57
set pad "..."
set current_text ""
set full_text ""

while true
    set raw_output (playerctl metadata --format '{{status}}|{{title}} - {{artist}}' 2>/dev/null)

    if test -z "$raw_output"
        set new_status "Stopped"
        set new_text ""
    else
        set new_status (echo $raw_output | cut -d'|' -f1)
        set new_text (echo $raw_output | cut -d'|' -f2-)
    end

    set new_len (string length -- "$new_text")

    # Reset scroll position when metadata changes
    if test "$new_text" != "$current_text"
        set current_text "$new_text"
        set len $new_len

        if test $len -le $max_len
            echo "$current_text"
            sleep 1
            continue
        end

        set full_text "$current_text$pad$pad"
    end

    # Display based on status
    if test "$new_status" != "Playing"
        # Paused/Stopped: show static text at current scroll position
        echo (string sub -l $max_len -- (if test $len -gt $max_len; echo $full_text; else; echo $current_text; end))
        sleep 1
    else
        # Playing: scroll
        echo (string sub -l $max_len -- $full_text)
        set full_text (string sub -s 2 -- $full_text)(string sub -l 1 -- $full_text)
        sleep 0.5
    end
end
