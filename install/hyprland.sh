#!/bin/bash
sudo dnf install ninja-build cmake wlroots-devel wayland-devel wayland-protocols-devel pango-devel cairo-devel file-devel libglvnd-devel libglvnd-core-devel libjpeg-turbo-devel libwebp-devel gcc-c++

cd git/sytem

# hyprlang
git clone https://github.com/hyprwm/hyprlang
cd hyprlang
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprlang -j 4
sudo cmake --install ./build

cd ..

# hyprpaper
git clone https://github.com/hyprwm/hyprpaper
cd hyprpaper
make all
cp build/hyprpaper ~/bin
