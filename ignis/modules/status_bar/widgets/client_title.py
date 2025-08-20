from ignis import widgets
from ignis.services.hyprland import HyprlandService

hyprland = HyprlandService.get_default()


def client_title() -> widgets.Label:
    return widgets.Label(
        ellipsize="end",
        max_width_chars=40,
        label=hyprland.active_window.bind("title"),
    )
