from ignis import widgets
from ignis.services.bluetooth import BluetoothService
from ignis.services.network import NetworkService
from ignis.window_manager import WindowManager

from .battery import get_battery

bluetooth = BluetoothService.get_default()
network = NetworkService.get_default()
window_manager = WindowManager.get_default()


def settings_menu() -> widgets.EventBox:
    bat = get_battery()
    return widgets.Button(
        css_classes=["cc-button"],
        on_click=lambda x: window_manager.toggle_window("ignis_CONTROL_CENTER"),
        child=widgets.Box(
            spacing=5,
            child=[
                widgets.Icon(
                    image=network.wifi.bind("icon_name"),
                    visible=network.wifi.bind("is_connected"),
                ),
                widgets.Icon(
                    image=network.ethernet.bind("icon_name"),
                    visible=network.ethernet.bind("is_connected"),
                ),
                widgets.Icon(
                    image=bluetooth.bind(
                        "powered",
                        transform=lambda powered: (
                            "bluetooth-symbolic" if powered else None
                        ),
                    )
                ),
                (
                    widgets.Icon(
                        image=bat.bind("icon_name"),
                        pixel_size=16,
                    )
                    if bat
                    else None
                ),
                (
                    widgets.Label(
                        label=bat.bind("percent", transform=lambda percent: str(int(percent)) + "%"),
                    )
                    if bat
                    else None
                ),
                widgets.Icon(image="system-shutdown-symbolic", pixel_size=16),
            ],
        ),
    )
