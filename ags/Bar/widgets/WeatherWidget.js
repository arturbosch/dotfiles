import { Commands, getScriptPath } from "../../options.js";

const weather = Variable(
  {},
  {
    poll: [
      30000,
      `python ${getScriptPath("weather.py")}`,
      (out) => JSON.parse(out),
    ],
  }
);

function WeatherWidget() {
  return Widget.Button({
    on_clicked: () => {
      Utils.execAsync(Commands.weatherApp);
    },
    child: Widget.Label({
      class_name: "weather",
      binds: [
        ["label", weather, "value", (value) => value.text || "󰇘"],
        ["tooltip-text", weather, "value", (value) => value.tooltip || "󰇘"],
      ],
    }),
  });
}

export default WeatherWidget;
