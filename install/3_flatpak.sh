#!/bin/env sh

## Install flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Apps

flatpak install flathub com.belmoussaoui.Authenticator # Two Factory Auth
flatpak install flathub com.github.neithern.g4music # Music Player
flatpak install flathub io.bassi.Amberol # Music Player
flatpak install fedora com.github.johnfactotum.Foliate # E-Book Reader
flatpak install flathub com.gitlab.newsflash # RSS Reader
flatpak install flathub com.system76.Popsicle # USB Flasher
flatpak install flathub com.valvesoftware.Steam # Steam Games
flatpak install flathub io.freetubeapp.FreeTube # Youtube Frontend
flatpak install flathub org.gnome.Boxes # Virtualization
flatpak install flathub org.onlyoffice.desktopeditors # Office Suite
flatpak install flathub com.github.huluti.Curtail # Image Minimizer
flatpak install flathub io.github.seadve.Kooha # Screen Recorder
flatpak install flathub org.gnome.gitlab.somas.Apostrophe # Markdown Editor
flatpak install flathub org.gnome.World.PikaBackup # Backup Solution
flatpak install fedora org.gnome.Connections # Remote Desktop
flatpak install flathub org.gnome.Solanum # Pomodoro Timer
flatpak install flathub com.github.tchx84.Flatseal # Manage Permissions
flatpak install flathub com.github.liferooter.textpieces # Text Manipulation
flatpak install flathub com.github.jeromerobert.pdfarranger # Merge an edit PDFs
flatpak install flathub org.gnome.World.Secrets # Password Store
flatpak install flathub com.lakoliu.Furtherance # Time Tracking
flatpak install flathub com.github.philip_scott.notes-up # Notes app

## uses old gnome platform and needs all latex package: 5gb+
# flatpak install flathub org.cvfosammmm.Setzer # latex editor
