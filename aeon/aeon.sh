#/bin/env bash

# Install missing software

## Add repo for ags
sudo zypper addrepo https://download.opensuse.org/repositories/home:Rethil/openSUSE_Tumbleweed/home:Rethil.repo
sudo zypper addrepo https://download.opensuse.org/repositories/home:Dead_Mozay/openSUSE_Tumbleweed/home:Dead_Mozay.repo
sudo zypper refresh
## System software
sudo transactional-update pkg install (cat ~/dotfiles/aeon/software.txt)

# Fish
sudo chsh artur --shell /usr/bin/fish
fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
cat ~/dotfiles/fish/fish_plugins | fisher install

# Rust
rustup default stable

# Sdkman / sdk fish plugin should install it
# curl -s "https://get.sdkman.io" | bash
