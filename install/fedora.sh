#/bin/env bash

install_command="sudo dnf install -y"
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
    local install_dir=$(dirname $(readlink -f $0))
    sh $install_dir/flatpak.sh
}

install_software() {
    # install one by one so we know if any package is broken/not present anymore
    for pkg in htop powertop curl wget zip unzip openssl git fish alacritty fzf tig meld tk tcl tldr asciinema thunderbird kakoune nodejs sway waybar swayidle swaylock wl-clipboard jq wlsunset pulseaudio-utils file-roller typescript gnome-extensions-app gimp rpi-imager pip jetbrains-mono-fonts-all git-lfs tokei xprop gnome-tweaks gettext bat lm_sensors; do
        $install_command $pkg
    done
}

install_rust_tools() {
    $install_command "cargo"
    cargo install ripgrep fd-find exa html-query
}

install_brave_browser() {
    $install_command dnf-plugins-core
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
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
    sudo lchsh $USER
    fisher update # reinstall plugins from fish/fish_plugins
}

install_pop_shell() {
    $install_command gnome-shell-extension-pop-shell
    $install_command nodejs-typescript
    git clone https://github.com/pop-os/shell.git ~/git/system/pop-shell
    cd ~/git/system/pop-shell/
    make local-install
}

echo "Update system?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) update_repos || error 'Error while updating repos.'; break;;
        No ) break;;
    esac
done

echo "Install additional software?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) install_software || error 'Error while installing software packages.'; break;;
        No ) break;;
    esac
done

echo "Install brave browser?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) $test_command brave-browser && echo 'Brave already installed.' || install_brave_browser || error 'Error while installing brave browser.'; break;;
        No ) break;;
    esac
done

echo "Install rust tools?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) install_rust_tools || error 'Error while installing rust packages.'; break;;
        No ) break;;
    esac
done

echo "Install flatpak packages?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) install_flatpak || error 'Error while installing flatpak packages.'; break;;
        No ) break;;
    esac
done

echo "Install powertop and tlp services?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) install_power_management || error 'Error while configuring powertop and tlp.'; break;;
        No ) break;;
    esac
done

echo "Configure fish shell?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) configure_fish || error 'Error while configuring fish.'; break;;
        No ) break;;
    esac
done

echo "Install sdkman?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) install_sdkman || error 'Error while configuring sdkman'; break;;
        No ) break;;
    esac
done

echo "Install pop shell tiling?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) install_pop_shell || error 'Error while installing pop-shell.'; break;;
        No ) break;;
    esac
done

echo "Done."
