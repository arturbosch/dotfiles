# OpenSuse Aeon + Hyprland

```sh
# install git+fish and reboot
sudo transactional-update pkg install git fish && reboot

# change shell to fish and re-login
sudo chsh $USER --shell /usr/bin/fish && loginctl terminate-user $USER

# zypper repos

# ags
sudo zypper addrepo https://download.opensuse.org/repositories/home:Rethil/openSUSE_Tumbleweed/home:Rethil.repo
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

# Sdkman / sdk fish plugin should install it
curl -s "https://get.sdkman.io" | bash

# Rust
rustup default stable
```
