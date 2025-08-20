from ignis.services.system_tray import SystemTrayItem, SystemTrayService
from ignis import widgets

system_tray = SystemTrayService.get_default()


def tray_item(item: SystemTrayItem) -> widgets.Button:
    if item.menu:
        menu = item.menu.copy()
    else:
        menu = None

    return widgets.Button(
        child=widgets.Box(
            child=[
                widgets.Icon(image=item.bind("icon"), pixel_size=16),
                menu,
            ]
        ),
        setup=lambda self: item.connect("removed", lambda x: self.unparent()),
        tooltip_text=item.bind("tooltip"),
        on_click=lambda x: menu.popup() if menu else None,
        on_right_click=lambda x: menu.popup() if menu else None,
        css_classes=["tray-item"],
    )


def tray():
    return widgets.Box(
        setup=lambda self: system_tray.connect(
            "added", lambda x, item: self.append(tray_item(item))
        ),
        spacing=10,
    )
