#!/bin/env sh

conf=$HOME/dotfiles

# setup kak plugins
chmod +x $conf/kak/install_kak_plug.sh
sh $conf/kak/install_kak_plug.sh

if (uname -a | grep -q pop-os)
then
    # brave browser
    sudo apt install apt-transport-https curl gnupg

    curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -

    echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

    sudo apt update

    sudo apt install brave-browser
else
    # theming
    curl https://gist.githubusercontent.com/hatoba29/52fd11a140deb8beeea5936e12bf566a/raw/e88db3ea5cf6a39374fafc6f87d0f87fa5c7fdf0/onedark.rofi --output ~/.config/rofi/onedark.rofi
    yay vertex-theme
fi

# Install vim-plug, then run :PlugClean and :PlugInstall inside nvim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Install yarn packages in home folder
mkdir ~/.yarn
yarn config set prefix ~/.yarn

