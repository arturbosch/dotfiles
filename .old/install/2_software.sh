#!/usr/bin/env sh

## install command and additional software
if (uname -a | grep -q pop-os)
then
    system="pop-os"
    install="sudo apt install"
    additional_software="printer-driver-gutenprint scrot pcmanfm tldr-py neovim-qt pavucontrol compton xautolock pasystray libnotify-bin brightnessctl python3-pip arp-scan"

    sudo apt remove cmdtest
    sudo apt remove yarn && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update
else
    system="manjaro"
    install="sudo pamac install"
    additional_software="rust tlpui go vlc brave-beta firefox ttf-jetbrains-mono pulseaudio-bluetooth moc"
    sudo pamac remove palemoon-bin
fi

## install common software
system_tools="htop powertop tlp curl wget zip unzip git fish alacritty fzf tig meld tk tcl tldr asciinema rofi timew neofetch brightnessctl"
office_tools="thunderbird gimp steam"
dev_tools="neovim kakoune hugo cargo nodejs yarn ruby"

$install $system_tools
$install $office_tools
$install $dev_tools

## install additional software
$install $additional_software

# fish plugin manager
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
sudo chsh $USER -s /usr/bin/fish

# rust tools
cargo install ripgrep fd-find exa
