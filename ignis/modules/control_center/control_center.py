from ignis import widgets
from ignis.window_manager import WindowManager

from .menu import opened_menu
from .widgets import (
    Brightness,
    # Media,
    # NotificationCenter,
    # QuickSettings,
    User,
    VolumeSlider,
)

window_manager = WindowManager.get_default()


def control_center(monitor_id: int = 0) -> widgets.Window:
    revealer = widgets.Revealer(
        transition_type="slide_left",
        child=widgets.Box(
            vertical=True,
            css_classes=["control-center"],
            child=[
                widgets.Box(
                    vertical=True,
                    css_classes=["control-center-widget"],
                    child=[
                        # QuickSettings(),
                        VolumeSlider("speaker"),
                        VolumeSlider("microphone"),
                        Brightness(),
                        User(),
                        # Media(),
                        # clock(),
                    ],
                ),
                # NotificationCenter(),
            ],
        ),
        transition_duration=300,
        reveal_child=True,
    )
    return widgets.RevealerWindow(
        visible=False,
        popup=True,
        kb_mode="on_demand",
        layer="top",
        css_classes=["unset"],
        anchor=["top", "right", "bottom", "left"],
        namespace="ignis_CONTROL_CENTER",
        child=widgets.Box(
            child=[
                widgets.Button(
                    vexpand=True,
                    hexpand=True,
                    css_classes=["unset"],
                    on_click=lambda x: window_manager.close_window(
                        "ignis_CONTROL_CENTER"
                    ),
                ),
                revealer,
            ],
        ),
        setup=lambda self: self.connect(
            "notify::visible", lambda x, y: opened_menu.set_value("")
        ),
        revealer=revealer,
    )
