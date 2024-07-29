import Applications from "resource:///com/github/Aylur/ags/service/applications.js";
import Network from "resource:///com/github/Aylur/ags/service/network.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import icons from "../icons.js";
import HoverableButton from "./HoverableButton.js";
import { ArrowToggleButton, Menu } from "./ToggleButton.js";

export const NetworkToggle = () =>
  ArrowToggleButton({
    name: "network",
    icon: Widget.Icon({
      connections: [
        [
          Network,
          (icon) => {
            icon.icon = Network.wifi?.iconName || "";
          },
        ],
      ],
    }),
    label: Widget.Label({
      class_name: "title",
      hpack: "start",
      label: "Network",
    }),
    status: Widget.Label({
      hpack: "start",
      connections: [
        [
          Network,
          (label) => {
            label.label = Network.wifi?.ssid || "Not Connected";
          },
        ],
      ],
    }),
    connection: [Network, () => Network.wifi?.enabled],
    deactivate: () => (Network.wifi.enabled = false),
    activate: () => {
      Network.wifi.enabled = true;
      Network.wifi.scan();
    },
  });

export const WifiSelection = () =>
  Menu({
    name: "network",
    icon: Widget.Icon({
      connections: [
        [
          Network,
          (icon) => {
            icon.icon = Network.wifi.icon_name;
          },
        ],
      ],
    }),
    title: Widget.Label("Wifi Selection"),
    menu_content: [
      Widget.Box({
        vertical: true,
        connections: [
          [
            Network,
            (box) =>
              (box.children = Network.wifi?.access_points.map((ap) =>
                HoverableButton({
                  on_clicked: () =>
                    Utils.execAsync(`nmcli device wifi connect ${ap.bssid}`),
                  child: Widget.Box({
                    children: [
                      Widget.Icon(ap.iconName),
                      Widget.Label(ap.ssid || ""),
                      ap.active &&
                        Widget.Icon({
                          icon: icons.tick,
                          hexpand: true,
                          hpack: "end",
                        }),
                    ],
                  }),
                })
              )),
          ],
        ],
      }),
      Widget.Separator(),
      HoverableButton({
        on_clicked: () =>
          Applications.query("gnome-control-center")?.[0].launch(),
        child: Widget.Box({
          children: [Widget.Icon(icons.settings), Widget.Label("Network")],
        }),
      }),
    ],
  });
