#!/usr/bin/env fish

if test (hyprctl monitors all | grep "Monitor" | wc -l) = 1
    hyprlock
end
