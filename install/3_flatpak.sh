#!/bin/env sh

## Install flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Apps

flatpak install flathub com.belmoussaoui.Authenticator # Two Factory Auth
flatpak install flathub io.bassi.Amberol # Music Player
flatpak install fedora com.github.johnfactotum.Foliate # E-Book Reader
flatpak install flathub com.gitlab.newsflash # RSS Reader
flatpak install flathub com.system76.Popsicle # USB Flasher
flatpak install flathub com.valvesoftware.Steam # Steam Games
flatpak install flathub io.freetubeapp.FreeTube # Youtube Frontend
flatpak install flathub org.gnome.Boxes # Virtualization
flatpak install flathub org.onlyoffice.desktopeditors # Office Suite
flatpak install flathub com.github.huluti.Curtail # Image Minimizer

