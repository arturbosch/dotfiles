#!/bin/bash

cd ~/git/system
git clone https://gitlab.gnome.org/tuxor1337/hidetopbar.git
cd hidetopbar
make
gnome-extensions install ./hidetopbar.zip
