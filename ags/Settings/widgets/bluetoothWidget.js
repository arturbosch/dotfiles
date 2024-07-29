//import Notifications from "resource:///com/github/Aylur/ags/service/notifications.js";
import Bluetooth from "resource:///com/github/Aylur/ags/service/bluetooth.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

import icons from "../../icons.js";

const BluetoothIndicator = (showDevices) =>
  Widget.Box({
    children: [
      Widget.Button({
        child: Widget.Icon({
          icon: Bluetooth.bind("enabled").transform((v) =>
            v ? icons.bluetooth.enabled : icons.bluetooth.disabled
          ),
        }),
        onPrimaryClick: () => Bluetooth.toggle(),
      }),
      Widget.Button({
        child: Widget.Label().hook(Bluetooth, (self) => {
          switch (Bluetooth.connected_devices?.length) {
            case 0:
              self.label = "No devices connected";
              break;
            case 1:
              self.label = Bluetooth.connected_devices[0].name;
              break;
            default:
              self.label = `${Bluetooth.connected_devices.length} devices connected`;
          }
        }),
        onPrimaryClick: () => (showDevices.value = !showDevices.value),
      }),
    ],
  });

const NetworkWidget = () => {
  const showDevices = Variable(false);
  return Widget.Box({
    vertical: true,
    children: [
      BluetoothIndicator(showDevices),
      Widget.Revealer({
        revealChild: showDevices.bind(),
        child: Widget.Scrollable({
          css: "min-height: 80px;",
          child: Widget.Box({ className: "devices", vertical: true }).hook(
            Bluetooth,
            (self) => {
              self.children = Bluetooth.devices.map((device) =>
                Widget.Button({
                  child: Widget.Box({
                    children: [
                      Widget.Icon(device.icon_name),
                      Widget.Label({ className: "label", label: device.name }),
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
