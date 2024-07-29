const battery = await Service.import("battery");

function BatteryWidget() {
  const label = Widget.Label().hook(
    battery,
    (self) => {
      self.label = ` ${battery.percent}%`;
      self.visible = battery.available;
    },
    "changed"
  );
  const icon = Widget.Icon({ icon: battery.bind("icon_name") });
  const tooltipRenderer = (timeRemaining) => {
    const format = new Date(timeRemaining * 1000).toISOString().slice(11, 19);
    const suffix = battery.charging || battery.charged ? "charge" : "discharge";
    return `${format} left to ${suffix}`;
  };
  return Widget.Box({
    class_name: "battery",
    visible: battery.bind("available"),
    children: [icon, label],
    tooltip_text: battery.bind("time_remaining").as(tooltipRenderer),
  });
}

export default BatteryWidget;
