import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { persistentWorkspaces, workspaceLabels } from "../../options.js";
const hyprland = await Service.import("hyprland");

export function Workspaces() {
  const activeId = hyprland.active.workspace.bind("id");
  const workspaces = persistentWorkspaces.map((id) =>
    Widget.Button({
      on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
      child: Widget.Label(workspaceLabels[id] ?? `${id}`),
      class_name: activeId.as((i) => `${i === id ? "focused" : ""}`),
    })
  );

  return Widget.Box({
    class_name: "workspaces",
    children: workspaces,
  });
}


export function Submap() {
  return Widget.Label({
    setup: (self) => {
      self.hook(hyprland, (label, submap) => {
        label.label = submap;
      }, "submap")
    },
  })
}


export default {
  Workspaces, Submap,
};
