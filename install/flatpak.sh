#!/bin/env sh

## Install flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Apps

inst="flatpak install -y"

$inst flathub com.belmoussaoui.Authenticator # Two Factory Auth
$inst flathub com.github.neithern.g4music # Music Player
$inst flathub io.bassi.Amberol # Music Player
$inst fedora com.github.johnfactotum.Foliate # E-Book Reader
$inst flathub com.gitlab.newsflash # RSS Reader
$inst flathub com.valvesoftware.Steam # Steam Games
$inst flathub com.github.Matoking.protontricks # Download missing dll's
$inst flathub io.freetubeapp.FreeTube # Youtube Frontend
$inst flathub org.gnome.Boxes # Virtualization
$inst flathub com.github.huluti.Curtail # Image Minimizer
$inst flathub io.github.seadve.Kooha # Screen Recorder
$inst flathub org.gnome.gitlab.somas.Apostrophe # Markdown Editor
$inst flathub org.gnome.World.PikaBackup # Backup Solution
$inst fedora org.gnome.Connections # Remote Desktop
$inst flathub org.gnome.Solanum # Pomodoro Timer
$inst flathub com.github.tchx84.Flatseal # Manage Permissions
$inst flathub com.github.liferooter.textpieces # Text Manipulation
$inst flathub com.github.jeromerobert.pdfarranger # Merge an edit PDFs
$inst flathub org.gnome.World.Secrets # Password Store
$inst flathub com.lakoliu.Furtherance # Time Tracking
$inst flathub md.obsidian.Obsidian # Notes / Wiki
$inst flathub uk.co.ibboard.cawbird # Twitter Client

# install vscodium via appimage so it will find all local programs and config
$inst flathub com.vscodium.codium # Editor

## uses old gnome platform and needs all latex package: 5gb+
$inst flathub org.cvfosammmm.Setzer # latex editor
