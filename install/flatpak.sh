#!/bin/env sh

## Add flathub repository if needed
## flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Apps
apps=(
com.belmoussaoui.Authenticator # Two Factor Auth
com.github.neithern.g4music # Music Player
com.github.johnfactotum.Foliate # E-Book Reader
com.gitlab.newsflash # RSS Reader
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
io.missioncenter.MissionCenter # task manager
app.drey.KeyRack # GUI for Keyrings
dev.bragefuglseth.Keypunch # Typing Test
)

tower=(
com.heroicgameslauncher.hgl
com.valvesoftware.Steam
io.github.thetumultuousunicornofdarkness.cpu-x
)

for app in "${apps[@]}"
do
  echo $app
  flatpak install flathub -y $app
done
