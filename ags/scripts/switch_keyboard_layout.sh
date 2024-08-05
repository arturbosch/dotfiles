#!/usr/bin/env bash
hyprctl switchxkblayout $(hyprctl devices -j | jq -c ".keyboards[] | select( .main == true ) .name" -r) next