#!/bin/bash

data=$(hyprctl activewindow -j)
groupSize=$(echo "$data" | jq -r '.grouped | length')
address=$(echo "$data" | jq -r '.address')
groupIndex=$(echo $data | jq --arg address "$address" -r '.grouped | index($address)')

IN_GROUP=0
if [[ "$groupSize" > 0 ]]; then
    IN_GROUP=1
fi

if [[ "$1" == "left" || "$1" == "l" ]]; then
    if [[ "$IN_GROUP" == 1 && "$groupIndex" > 0  ]]; then
        hyprctl dispatch changegroupactive b
    else
        hyprctl dispatch movefocus l
    fi
else
    if [[ "$IN_GROUP" == 1 && "$((groupIndex + 1))" < "$groupSize" ]]; then
        hyprctl dispatch changegroupactive f
    else
        hyprctl dispatch movefocus r
    fi
fi
