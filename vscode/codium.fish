#!/bin/env fish

# VSCodium

set extfile ~/dotfiles/vscode/extensions.txt
set settingsfile ~/dotfiles/vscode/settings.json

if test (command -q "codium")
    set codiumSettingsFile ~/.config/VSCodium/User/settings.json
else
    set codiumSettingsFile ~/.var/app/com.vscodium.codium/config/VSCodium/User/settings.json
    alias codium "flatpak run com.vscodium.codium"
end

function export_settings
    cp $codiumSettingsFile $settingsfile
end

function import_settings
    cp $settingsfile $codiumSettingsFile
end

function export_extensions
    codium --list-extensions >> $extfile
    sort -u -o $extfile $extfile
end

function import_extensions
    for ext in (cat $extfile | string split "\n")
        echo "Installing ..." $ext
        codium --install-extension $ext
    end
end

# Main

if test $argv[1]
    echo ($argv[1])
else
    echo "Usage: ./codium.fish [function_name]"
end