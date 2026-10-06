# OpenSuse/Fedora + Hyprland

```sh
# install git+fish and reboot
sudo zypper install git fish

# change shell to fish and re-login
sudo chsh $USER --shell /usr/bin/fish && loginctl terminate-user $USER

# download dotfiles
cd ~
git clone https://github.com/arturbosch/dotfiles
cd dotfiles

# extra repo: noctalia shell (openSUSE Slowroll)
sudo zypper addrepo --refresh --name noctalia-v5 https://download.opensuse.org/repositories/home:neifua:Noctalia/openSUSE_Slowroll/home:neifua:Noctalia.repo

# defaults & software
./dots all

# Nerd Font
wget -P ~/.local/share/fonts/ https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
unzip -d ~/.local/share/fonts/ ~/.local/share/fonts/JetBrainsMono.zip

# Sdkman / sdk fish plugin should install it
curl -s "https://get.sdkman.io" | bash

# Rust
rustup-init

# Pi
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```
