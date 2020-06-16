#!/bin/env sh
# copy home backup and update os

if (uname -a | grep -q ubuntu)

then # regolith specific

    sudo apt update && sudo apt upgrade -y

    # enable middle and right click for touchpad
    gsettings set org.gnome.desktop.peripherals.touchpad click-method areas

else # manjaro specific

    sudo pamac update && sudo pamac upgrade

fi

# common part

# map capslock to escape
setxkbmap -option caps:escape

# enable power management

if (systemctl | grep -q powertop)
then
    echo "powertop already configured"
else
    sudo sh -c "echo -e '[Unit]\nDescription=PowerTop\n\n[Service]\nType=oneshot\nRemainAfterExit=true\nExecStart=/usr/bin/powertop --auto-tune\n\n[Install]\nWantedBy=multi-user.target\n' > /etc/systemd/system/powertop.service"
    sudo systemctl enable --now powertop.service
fi
