import icons from "../icons.js";
import ToggleIconButton from "../widgets/ToggleIconButton.js";
import BatteryWidget from "./widgets/BatteryWidget.js";
import ClockWidget from "./widgets/ClockWidget.js";
import KeyboardLayout from "./widgets/KeyboardLayout.js";
import PowerProfileWidget from "./widgets/PowerProfileWidget.js";
import SysTray from "./widgets/SysTray.js";
import TodoTxtWidget from "./widgets/TodoTxtWidget.js";
import WeatherWidget from "./widgets/WeatherWidget.js";
import Workspaces from "./widgets/Workspaces.js";

function Left() {
  return Widget.Box({
    spacing: 8,
    children: [TodoTxtWidget(), SysTray()],
  });
}

function Center() {
  return Widget.Box({
    spacing: 8,
    children: [WeatherWidget(), ClockWidget(), KeyboardLayout()],
  });
}

function Right(monitor = 0) {
  return Widget.Box({
    hpack: "end",
    spacing: 8,
    children: [
      Workspaces(),
      PowerProfileWidget(),
      BatteryWidget(),
      ToggleIconButton(() => {
        const id = `new-settings-${monitor}`;
        App.toggleWindow(id);
      }, Widget.Icon({ icon: icons.session.shutdown })),
    ],
  });
}

function Bar(monitor = 0) {
  return Widget.Window({
    name: `bar-${monitor}`,
    class_name: "bar",
    monitor,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      start_widget: Left(),
      center_widget: Center(),
      end_widget: Right(monitor),
    }),
  });
}

export default Bar;
