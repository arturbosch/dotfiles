#!/bin/env sh

conf=$HOME/dotfiles

# setup kak plugins
chmod +x $conf/kak/install_kak_plug.sh $conf/kak/install_kak_plug.sh

# brave browser
sudo apt install apt-transport-https curl
curl -s https://brave-browser-apt-beta.s3.brave.com/brave-core-nightly.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-prerelease.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-beta.list
sudo apt update
sudo apt install brave-browser-beta
