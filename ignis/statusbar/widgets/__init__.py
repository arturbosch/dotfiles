from .battery import battery, get_battery
from .clock import clock
from .keyboard_layout import keyboard_layout
from .power_menu import power_menu
from .settings_menu import settings_menu
from .tray import tray
from .workspaces import workspaces
from .client_title import client_title

__all__ = [
    "battery",
    "get_battery",
    "clock",
    "client_title",
    "workspaces",
    "tray",
    "power_menu",
    "keyboard_layout",
    "settings_menu",
]
