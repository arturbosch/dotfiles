from ignis import widgets
from ignis.services.hyprland import HyprlandService

hyprland = HyprlandService.get_default()


def keyboard_layout() -> widgets.EventBox:
    def transform(value: str):
        return {
            "English (US)": "[EN]",
            "German": "[DE]",
            "Russian": "[RU]",
        }[value]

    return widgets.EventBox(
        on_click=lambda self: hyprland.main_keyboard.switch_layout("next"),
        child=[
            widgets.Label(
                label=hyprland.main_keyboard.bind("active_keymap", transform=transform)
            )
        ],
    )
