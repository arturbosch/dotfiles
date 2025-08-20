from ignis import widgets

from ignis.services.hyprland import HyprlandService, HyprlandWorkspace
from ignis.services.niri import NiriService, NiriWorkspace

hyprland = HyprlandService.get_default()
niri = NiriService.get_default()


def hyprland_workspace_button(workspace: HyprlandWorkspace) -> widgets.Button:
    widget = widgets.Button(
        css_classes=["workspace"],
        on_click=lambda x: workspace.switch_to(),
        child=widgets.Label(label=str(workspace.id)),
    )
    if workspace.id == hyprland.active_workspace.id:
        widget.add_css_class("active")

    return widget


def niri_workspace_button(workspace: NiriWorkspace) -> widgets.Button:
    idx_to_show = 0 if workspace.idx == 10 else workspace.idx
    widget = widgets.Button(
        css_classes=["workspace"],
        on_click=lambda x: workspace.switch_to(),
        child=widgets.Label(label=str(idx_to_show)),
    )
    if workspace.is_active:
        widget.add_css_class("active")

    return widget


def workspace_button(workspace) -> widgets.Button:
    if hyprland.is_available:
        return hyprland_workspace_button(workspace)
    elif niri.is_available:
        return niri_workspace_button(workspace)
    else:
        return widgets.Button()


def hyprland_scroll_workspaces(direction: str) -> None:
    current = hyprland.active_workspace["id"]
    if direction == "up":
        target = current - 1
        hyprland.switch_to_workspace(target)
    else:
        target = current + 1
        if target == 11:
            return
        hyprland.switch_to_workspace(target)


def niri_scroll_workspaces(monitor_name: str, direction: str) -> None:
    current = list(
        filter(lambda w: w.is_active and w.output == monitor_name, niri.workspaces)
    )[0].idx
    if direction == "up":
        target = current + 1
        niri.switch_to_workspace(target)
    else:
        target = current - 1
        niri.switch_to_workspace(target)


def scroll_workspaces(direction: str, monitor_name: str = "") -> None:
    if hyprland.is_available:
        hyprland_scroll_workspaces(direction)
    elif niri.is_available:
        niri_scroll_workspaces(monitor_name, direction)
    else:
        pass


def hyprland_workspaces() -> widgets.EventBox:
    return widgets.EventBox(
        on_scroll_up=lambda x: scroll_workspaces("up"),
        on_scroll_down=lambda x: scroll_workspaces("down"),
        css_classes=["workspaces"],
        spacing=5,
        child=hyprland.bind_many(  # bind also to active_workspace to regenerate workspaces list when active workspace changes
            ["workspaces", "active_workspace"],
            transform=lambda workspaces, active_workspace: [
                workspace_button(i) for i in workspaces if i.id >= 0
            ],
        ),
    )


def niri_workspaces(monitor_name: str) -> widgets.EventBox:
    return widgets.EventBox(
        on_scroll_up=lambda x: scroll_workspaces("up", monitor_name),
        on_scroll_down=lambda x: scroll_workspaces("down", monitor_name),
        css_classes=["workspaces"],
        spacing=5,
        child=niri.bind(
            "workspaces",
            transform=lambda value: [
                workspace_button(i) for i in value if i.output == monitor_name
            ],
        ),
    )


def workspaces(monitor_name: str) -> widgets.EventBox:
    if hyprland.is_available:
        return hyprland_workspaces()
    elif niri.is_available:
        return niri_workspaces(monitor_name)
    else:
        return widgets.EventBox()
