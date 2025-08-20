from ignis import widgets
from ignis.services.upower import UPowerService, UPowerDevice
from typing import Optional

upower = UPowerService.get_default()

def get_battery() -> Optional[UPowerDevice]:
    batteries = upower.batteries
    if not batteries:
        return None
    return batteries[0]


def battery() -> widgets.Box:
    bat = get_battery()
    if not bat:
        return widgets.Box()

    def charging_text(charging: bool, energy_rate: float, time_remaining: int):
        minutes_until = int(time_remaining / 60)
        hours = minutes_until // 60
        mins = minutes_until % 60
        text = "Charging" if charging else "Discharging"
        return f"{text}: {hours}:{mins}h, {energy_rate:.2f} mW."

    # render the first one
    charging_prop = bat.bind_many(
        ["charging", "energy_rate", "time_remaining"], transform=charging_text
    )
    return widgets.Box(
        css_classes=["bar_module"],
        child=[
            widgets.Icon(
                image=bat.bind("icon_name"),
                tooltip_text=charging_prop,
                style="margin-right: 2px;",
            ),
            widgets.Label(
                label=bat.bind("percent", transform=lambda value: str(int(value))),
                tooltip_text=charging_prop,
            ),
            widgets.Label(label="%"),
        ],
    )
