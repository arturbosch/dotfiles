import App from "resource:///com/github/Aylur/ags/app.js";

const weather = Variable(
  {},
  {
    poll: [
      30000,
      `python ${App.configDir}/scripts/weather.py`,
      (out) => JSON.parse(out),
    ],
  }
);

function WeatherWidget() {
  return Widget.Label({
    class_name: "weather",
    binds: [
      ["label", weather, "value", (value) => value.text || "󰇘"],
      ["tooltip-text", weather, "value", (value) => value.tooltip || "󰇘"],
    ],
  });
}

export default WeatherWidget;
