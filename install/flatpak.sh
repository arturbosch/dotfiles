#!/bin/env sh

## Add flathub repository if needed
## flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Apps
apps=(
com.belmoussaoui.Authenticator # Two Factor Auth
com.github.neithern.g4music # Music Player
com.github.johnfactotum.Foliate # E-Book Reader
com.gitlab.newsflash # RSS Reader
com.valvesoftware.Steam # Steam Games
com.github.Matoking.protontricks # Download missing dll's
io.freetubeapp.FreeTube # Youtube Frontend
org.gnome.Boxes # Virtualization
com.github.huluti.Curtail # Image Minimizer
org.gnome.Connections # Remote Desktop
com.github.tchx84.Flatseal # Manage Permissions
com.github.liferooter.textpieces # Text Manipulation
com.github.jeromerobert.pdfarranger # Merge an edit PDFs
org.gnome.World.Secrets # Password Store
md.obsidian.Obsidian # Notes / Wiki
com.nextcloud.desktopclient.nextcloud # Nextcloud Client
org.x.Warpinator # Local Network File Sharing
org.cvfosammmm.Setzer # latex editor
io.missioncenter.MissionCenter # task manager
)

for app in "${apps[@]}"
do
  echo $app
  flatpak install flathub -y $app
done
