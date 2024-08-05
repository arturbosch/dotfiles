import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { formatKeyboardLayout } from "../../options.js";
import { switchkeyboardLayout } from "../../tools.js";

const hyprland = await Service.import("hyprland");

const KeyboardLayout = () =>
  Widget.Button({
    on_clicked: () => switchkeyboardLayout(),
    child: Widget.Label({
      setup: (self) => {
        console.log("in setip");
        Utils.execAsync("hyprctl ");
      },
      connections: [
        [
          hyprland,
          (label, _kbName, layoutName) => {
            label.label = formatKeyboardLayout(layoutName);
          },
          "keyboard-layout",
        ],
      ],
    }),
  });

export default KeyboardLayout;
