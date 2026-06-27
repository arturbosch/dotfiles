# OpenSuse/Fedora + Hyprland

```sh
# install git+fish and reboot
sudo zypper install git fish

# change shell to fish and re-login
sudo chsh $USER --shell /usr/bin/fish && loginctl terminate-user $USER

# zypper repos
# adw-gtk3-theme
sudo zypper addrepo https://download.opensuse.org/repositories/home:Dead_Mozay/openSUSE_Tumbleweed/home:Dead_Mozay.repo

sudo zypper refresh

# download dotfiles
cd ~
git clone https://github.com/arturbosch/dotfiles
cd dotfiles

# defaults & software
./dots links
./dots defaults
./dots fisher
./dots software
./dots flatpak

# Nerd Font
wget -P ~/.local/share/fonts/ https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
unzip -d ~/.local/share/fonts/ ~/.local/share/fonts/JetBrainsMono.zip

# zscroll for waybar
git clone https://github.com/noctuid/zscroll
cd zscroll
sudo python3 setup.py install

# Sdkman / sdk fish plugin should install it
curl -s "https://get.sdkman.io" | bash

# Rust
rustup-init

# Pi
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```
