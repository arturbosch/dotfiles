//import Notifications from "resource:///com/github/Aylur/ags/service/notifications.js";
import Network from "resource:///com/github/Aylur/ags/service/network.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

const WifiIndicator = (showNetworks) =>
  Widget.Box({
    children: [
      Widget.Button({
        child: Widget.Icon({
          icon: Network.wifi.bind("icon_name"),
        }),
        onPrimaryClick: () => Network.toggleWifi(),
      }),
      Widget.Button({
        child: Widget.Label({
          label: Network.wifi
            .bind("ssid")
            .as((it) => (Boolean(it) ? it : "No wifi connected")),
        }),
        onPrimaryClick: () => {
          Network.wifi.scan();
          showNetworks.value = !showNetworks.value;
        },
      }),
    ],
  });

const WiredIndicator = (showNetworks) =>
  Widget.Box({
    spacing: 20,
    children: [
      Widget.Button({
        child: Widget.Icon({
          icon: Network.wired.bind("icon_name"),
        }),
      }),
      Widget.Button({
        child: Widget.Label({
          label: "Wired",
        }),
        onPrimaryClick: () => {
          Network.wifi.scan();
          showNetworks.value = !showNetworks.value;
        },
      }),
    ],
  });

const NetworkWidget = () => {
  const showNetworks = Variable(false);
  return Widget.Box({
    vertical: true,
    children: [
      Widget.Stack({
        items: [
          ["wifi", WifiIndicator(showNetworks)],
          ["wired", WiredIndicator(showNetworks)],
        ],
        shown: Network.bind("primary").transform((p) => p || "wifi"),
      }),
      Widget.Revealer({
        revealChild: showNetworks.bind(),
        child: Widget.Scrollable({
          child: Widget.Box({ className: "devices", vertical: true }).hook(
            Network,
            (self) => {
              self.children = Network.wifi.access_points.map((accessPoint) =>
                Widget.Button({
                  child: Widget.Box({
                    children: [
                      Widget.Icon(accessPoint.iconName),
                      Widget.Label({
                        className: "label",
                        label: accessPoint.ssid,
                      }),
                    ],
                  }),
                })
              );
            }
          ),
        }),
      }),
    ],
  });
};

export default NetworkWidget;
