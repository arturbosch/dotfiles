#!/bin/env sh
# https://docs.qtile.org/en/latest/manual/install/index.html#installing-from-source
pip install xcffib
pip install --no-cache-dir cairocffi
sudo apt-get install libpangocairo-1.0-0
pip install dbus-next
pip install psutil

cd ~/git/system
git pull
#git clone git://github.com/qtile/qtile.git
#cd qtile
#pip install .

