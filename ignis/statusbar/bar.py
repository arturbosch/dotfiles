from ignis import utils, widgets
from ignis.services.hyprland import HyprlandService

from .widgets import (
    client_title,
    clock,
    settings_menu,
    tray,
    workspaces,
)

hyprland = HyprlandService.get_default()


def left(monitor_name: str) -> widgets.Box:
    return widgets.Box(child=[workspaces(monitor_name), client_title()], spacing=10)


def center() -> widgets.Box:
    return widgets.Box(
        child=[
            clock(),
        ],
        spacing=10,
    )


def right() -> widgets.Box:
    return widgets.Box(
        child=[
            tray(),
            settings_menu(),
        ],
        spacing=10,
    )


def bar(monitor_id: int = 0) -> widgets.Window:
    monitor_name = utils.get_monitor(monitor_id).get_connector()  # type: ignore
    return widgets.Window(
        namespace=f"ignis_bar_{monitor_id}",
        monitor=monitor_id,
        anchor=["left", "top", "right"],
        exclusivity="exclusive",
        child=widgets.CenterBox(
            css_classes=["bar"],
            start_widget=left(monitor_name),  # type: ignore
            center_widget=center(),
            end_widget=right(),
        ),
    )
