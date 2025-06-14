#!/bin/bash

array=(
https://extensions.gnome.org/extension/3193/blur-my-shell/
https://extensions.gnome.org/extension/1319/gsconnect/
https://extensions.gnome.org/extension/5470/weather-oclock/
https://extensions.gnome.org/extension/615/appindicator-support/
https://extensions.gnome.org/extension/16/auto-move-windows/
https://extensions.gnome.org/extension/600/launch-new-instance/
https://extensions.gnome.org/extension/570/todotxt/
https://extensions.gnome.org/extension/5489/search-light/
https://extensions.gnome.org/extension/545/hide-top-bar/
https://extensions.gnome.org/extension/6099/paperwm/
)

for i in "${array[@]}"
do
    EXTENSION_ID=$(curl -s $i | grep -oP 'data-uuid="\K[^"]+')
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$EXTENSION_ID" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    wget -O ${EXTENSION_ID}.zip "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force ${EXTENSION_ID}.zip
    if ! gnome-extensions list | grep --quiet ${EXTENSION_ID}; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${EXTENSION_ID}
    fi
    gnome-extensions enable ${EXTENSION_ID}
    rm ${EXTENSION_ID}.zip
done
