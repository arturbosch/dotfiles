export const timeFormat = "+%a %e. %b %H:%M";

export const workspaceLabels = Object.freeze({
  1: "一",
  2: "二",
  3: "三",
  4: "四",
  5: "五",
  6: "六",
  7: "七",
  8: "八",
  9: "九",
  10: "十",
  urgent: "",
  focused: "",
  default: "",
});

export const persistentWorkspaces = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

export const Commands = Object.freeze({
  lockSession: "hyprlock",
  shutdown: "systemctl poweroff",
  screenshotShortcut: "hyprshot -m window",
  settingsApp: "gnome-control-center",
  weatherApp: "gnome-weather",
});

export const monitors = [0];
