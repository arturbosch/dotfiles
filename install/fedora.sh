install_command="sudo dnf install"
update_command="sudo dnf update"
test_command="sudo dnf list"

error() {
    printf "ERROR:\\n%s\\n" "$1" >&2;
    exit 1;
}

update_repos() {
    $update_command
}

install_flatpak() {
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub com.vscodium.codium
    flatpak install flathub com.valvesoftware.Steam
    flatpak install flathub io.lbry.lbry-app
}

install_software() {
    for pkg in htop curl wget zip unzip git fish alacritty fzf tig meld tk tcl tldr asciinema rofi thunderbird kakoune nodejs sway waybar swayidle swaylock wl-clipboard jq pulseaudio-utils file-roller; do
        $install_command $pkg  
    done
}

install_rust_tools() {
    $install_command "cargo"
    cargo install ripgrep fd-find exa
}

install_brave_browser() {
    $install_command install dnf-plugins-core
    $install_command config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    $install_command brave-browser
}

install_power_management() {
    $install_command powertop
    $install_command tlp
    systemctl enable --now tlp.service || error 'Error while enabling tlp.service'
    if (systemctl | grep -q powertop)
    then
        echo "powertop already configured."
    else
        sudo sh -c "echo -e '[Unit]\nDescription=PowerTop\n\n[Service]\nType=oneshot\nRemainAfterExit=true\nExecStart=/usr/bin/powertop --auto-tune\n\n[Install]\nWantedBy=multi-user.target\n' > /etc/systemd/system/powertop.service"
        sudo systemctl enable --now powertop.service
    fi
}

install_sdkman() {
    curl -s "https://get.sdkman.io" | bash
    . ${SDKMAN_DIR}/bin/sdkman-init.sh
}

configure_fish() {
    curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
    sudo chsh $USER -s /usr/bin/fish
}

install_pop_shell() {
    $install_command gnome-shell-extension-pop-shell
    $install_command nodejs-typescript
    git clone https://github.com/pop-os/shell.git ~/git/system/pop-shell
    cd ~/git/system/pop-shell/
    make local-install
}

update_repos || error 'Error while updating repos.'
$test_command brave-browser && echo 'Brave already installed.' || install_brave_browser || error 'Error while installing brave browser.'
install_software || error 'Error while installing software packages.'
configure_fish || error 'Error while configuring fish.'
install_rust_tools || error 'Error while installing rust packages.'
install_flatpak || error 'Error while installing flatpak packages.'
install_power_management || error 'Error while configuring powertop and tlp.'
install_sdkman || error 'Error while configuring sdkman'
install_pop_shell || error 'Error while installing pop-shell.'
