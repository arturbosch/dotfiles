#!/bin/env sh

## Install flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Apps

inst="flatpak install -y"

$inst flathub com.belmoussaoui.Authenticator # Two Factory Auth
$inst flathub com.github.neithern.g4music # Music Player
$inst fedora com.github.johnfactotum.Foliate # E-Book Reader
$inst flathub com.gitlab.newsflash # RSS Reader
$inst flathub com.valvesoftware.Steam # Steam Games
$inst flathub com.github.Matoking.protontricks # Download missing dll's
$inst flathub io.freetubeapp.FreeTube # Youtube Frontend
$inst flathub org.gnome.Boxes # Virtualization
$inst flathub com.github.huluti.Curtail # Image Minimizer
$inst flathub org.gnome.World.PikaBackup # Backup Solution
$inst fedora org.gnome.Connections # Remote Desktop
$inst flathub com.github.tchx84.Flatseal # Manage Permissions
$inst flathub com.github.liferooter.textpieces # Text Manipulation
$inst flathub com.github.jeromerobert.pdfarranger # Merge an edit PDFs
$inst flathub org.gnome.World.Secrets # Password Store
$inst flathub md.obsidian.Obsidian # Notes / Wiki
$inst flathub com.nextcloud.desktopclient.nextcloud # Nextcloud Client
$inst flathub org.x.Warpinator # Local Network File Sharing

## uses old gnome platform and needs all latex package: 5gb+
$inst flathub org.cvfosammmm.Setzer # latex editor
