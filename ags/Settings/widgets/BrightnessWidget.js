import icons from "../../icons.js";
import { formatPercent } from "../../utils.js";
import brightness from "./BrightnessService.js";

function BrightnessWidget() {
  const slider = Widget.Slider({
    hexpand: true,
    draw_value: false,
    on_change: (self) => (brightness.screen_value = self.value),
    value: brightness.bind("screen_value"),
    tooltip_text: brightness.bind("screen_value").as(formatPercent),
  });

  const icon = Widget.Icon({ icon: icons.brightness });

  return Widget.Box({
    class_name: "brightness",
    css: "min-width: 180px",
    children: [Widget.Button({ child: icon }), slider],
  });
}

export default BrightnessWidget;
