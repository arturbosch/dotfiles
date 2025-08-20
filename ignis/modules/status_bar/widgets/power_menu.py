import asyncio

from ignis import utils, widgets
from ignis.menu_model import IgnisMenuItem, IgnisMenuModel, IgnisMenuSeparator
from ignis.services.hyprland import HyprlandService

hyprland = HyprlandService.get_default()


def create_exec_task(cmd: str) -> None:
    # use create_task to run async function in a regular (sync) one
    asyncio.create_task(utils.exec_sh_async(cmd))


def power_menu() -> widgets.Button:
    menu = widgets.PopoverMenu(
        model=IgnisMenuModel(
            IgnisMenuItem(
                label="Lock",
                on_activate=lambda x: create_exec_task("hyprlock"),
            ),
            IgnisMenuSeparator(),
            IgnisMenuItem(
                label="Suspend",
                on_activate=lambda x: create_exec_task("systemctl suspend"),
            ),
            IgnisMenuItem(
                label="Hibernate",
                on_activate=lambda x: create_exec_task("systemctl hibernate"),
            ),
            IgnisMenuSeparator(),
            IgnisMenuItem(
                label="Reboot",
                on_activate=lambda x: create_exec_task("systemctl reboot"),
            ),
            IgnisMenuItem(
                label="Shutdown",
                on_activate=lambda x: create_exec_task("systemctl poweroff"),
            ),
            IgnisMenuSeparator(),
            IgnisMenuItem(
                label="Logout",
                enabled=hyprland.is_available,
                on_activate=lambda x: create_exec_task("hyprctl dispatch exit 0"),
            ),
        ),
    )
    return widgets.Button(
        child=widgets.Box(
            child=[widgets.Icon(image="system-shutdown-symbolic", pixel_size=16), menu]
        ),
        on_click=lambda x: menu.popup(),
    )
