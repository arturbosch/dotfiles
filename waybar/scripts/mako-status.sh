#!/usr/bin/env sh
# waybar custom/mako status: DND state + active notification count
if makoctl mode | grep -qx do-not-disturb; then
    printf '{"text":"󰂛","tooltip":"Do Not Disturb","class":"dnd"}\n'
else
    count=$(makoctl list 2>/dev/null | jq '.data[0] | length' 2>/dev/null)
    printf '{"text":"󰂚","tooltip":"%s notification(s)","class":"active"}\n' "${count:-0}"
fi
