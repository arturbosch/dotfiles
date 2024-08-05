const systemtray = await Service.import("systemtray");

/** @param {import('types/service/systemtray').TrayItem} item */
function TrayItem(item) {
  return Widget.Button({
    child: Widget.Icon({ icon: item.bind("icon") }),
    tooltip_markup: item.bind("tooltip_markup"),
    on_primary_click: (_, event) => item.activate(event),
    on_secondary_click: (_, event) => item.openMenu(event),
  });
}

function SysTray() {
  const items = systemtray.bind("items").as((items) => items.map(TrayItem));
  return Widget.Box({
    children: items,
  });
}

export default SysTray;
