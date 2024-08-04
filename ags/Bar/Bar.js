import icons from "../icons.js";
import Spacer from "../widgets/Separator.js";
import ToggleIconButton from "../widgets/ToggleIconButton.js";
import BatteryWidget from "./widgets/BatteryWidget.js";
import ClockWidget from "./widgets/ClockWidget.js";
import SysTray from "./widgets/SysTray.js";
import WeatherWidget from "./widgets/WeatherWidget.js";
import Workspaces from "./widgets/Workspaces.js";

function Left() {
  return Widget.Box({
    spacing: 8,
    children: [SysTray()],
  });
}

function Center() {
  return Widget.Box({
    spacing: 8,
    children: [WeatherWidget(), ClockWidget()],
  });
}

function Right(monitor = 0) {
  return Widget.Box({
    hpack: "end",
    spacing: 8,
    children: [
      Workspaces(),
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
