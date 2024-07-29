import icons from "../icons.js";
import { Commands } from "../options.js";
import BrightnessWidget from "./widgets/BrightnessWidget.js";
import AudioInput from "./widgets/audioInput.js";
import AudioOutput from "./widgets/audioOutput.js";
import BluetoothWidget from "./widgets/bluetoothWidget.js";
import NetworkWidget from "./widgets/networkWidget.js";
import Session from "./widgets/session.js";

function SettingsButton(icon, action) {
  return Widget.Button({
    class_name: "settings-button circular",
    on_clicked: action,
    child: Widget.Icon({ icon: icon }),
  });
}

function Row(children) {
  return Widget.Box({
    className: "row",
    homogeneous: true,
    vertical: false,
    children,
  });
}

function OptionsRow() {
  const left = Widget.Box({
    homogeneous: true,
    vertical: false,
    spacing: 8,
    children: [
      SettingsButton(icons.apps.screenshot, () =>
        Utils.execAsync(Commands.screenshotShortcut)
      ),
      SettingsButton(icons.apps.settings, () =>
        Utils.execAsync(Commands.settingsApp)
      ),
    ],
  });
  const right = Widget.Box({
    homogeneous: true,
    vertical: false,
    spacing: 8,
    children: [
      SettingsButton(icons.session.lock, () =>
        Utils.execAsync(Commands.lockSession)
      ),
      // TODO make poweroff a menu for logout, restart, poweroff
      SettingsButton(icons.session.shutdown, () =>
        Utils.execAsync(Commands.shutdown)
      ),
    ],
  });
  return Row([left, Widget.Box(), right]);
}

const Settings = (monitor = 0) => {
  const name = `new-settings-${monitor}`;
  return Widget.Window({
    name: name,
    className: "settings",
    setup: (self) => self.keybind("Escape", () => App.closeWindow(name)),
    visible: false,
    keymode: "exclusive",
    monitor,
    anchor: ["top", "right"],
    child: Widget.Box({
      spacing: 24,
      vertical: true,
      className: "box",
      children: [
        Row([Session()]),
        Row([AudioOutput(), AudioInput()]),
        Row([BrightnessWidget()]),
        Row([NetworkWidget(), BluetoothWidget()]),
      ],
    }),
  });
};

export default Settings;
