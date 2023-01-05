#!/usr/bin/sh
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
export _JAVA_AWT_WM_NONREPARENTING=1
export GDK_BACKEND=wayland
export XDG_CURRENT_DESKTOP=Unity

if [[ -f /usr/bin/sway ]]; then
	sway
fi
