import { exec } from "resource:///com/github/Aylur/ags/utils.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

import icons from "../../icons.js";

const Session = () => {
  const { lock, logout, restart, shutdown } = icons.session;

  return Widget.CenterBox({
    spacing: 20,
    className: "vert",
    startWidget: Widget.Box({
      spacing: 20,
      children: [
        Widget.Button({
          child: Widget.Icon(icons.apps.screenshot),
          onPrimaryClickRelease: () => {
            exec("hyprshot -m window");
          },
        }),
        Widget.Button({
          child: Widget.Icon(icons.apps.settings),
          onPrimaryClickRelease: () => {
            exec("gnome-control-center");
          },
        }),
      ],
    }),
    centerWidget: Widget.Label(),
    endWidget: Widget.Box({
      spacing: 20,
      children: [
        Widget.Button({
          child: Widget.Icon(lock),
          onPrimaryClickRelease: () => {
            exec("loginctl lock-session");
          },
        }),
        Widget.Button({
          child: Widget.Icon(logout),
          onPrimaryClickRelease: () => {
            exec("hyprctl dispatch exit");
          },
        }),
        Widget.Button({
          child: Widget.Icon(restart),
          onPrimaryClickRelease: () => {
            exec("systemctl reboot");
          },
        }),
        Widget.Button({
          child: Widget.Icon(shutdown),
          onPrimaryClickRelease: () => {
            exec("systemctl poweroff");
          },
        }),
      ],
    }),
  });
};

export default Session;
