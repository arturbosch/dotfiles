#!/bin/env sh
## Enables steam to detect e.g. ps4 controllers
sudo wget --output-document /etc/udev/rules.d/60-steam-input.rules https://raw.githubusercontent.com/rpmfusion/steam/master/60-steam-input.rules

