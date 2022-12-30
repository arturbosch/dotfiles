#!/bin/sh
cd ~/git/system
git clone https://github.com/helix-editor/helix
cd helix
cargo install --path helix-term
