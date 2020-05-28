#!/usr/bin/env sh
mkdir -p $HOME/.config/kak/plugins
git clone https://github.com/andreyorst/plug.kak.git ~/.config/kak/plugins/plug.kak

# execute inside kak: source "%val{config}/plugins/plug.kak/rc/plug.kak"
