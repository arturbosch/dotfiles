import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { formatKeyboardLayout } from "../../options.js";
import { execScript } from "../../tools.js";

const hyprland = await Service.import("hyprland");

export function switchkeyboardLayout() {
  return execScript("switch_keyboard_layout.sh");
}

export function getCurrentKeyboardLayout() {
  return execScript("get_keyboard_layout.sh");
}

function KeyboardLayout() {
  return Widget.Button({
    on_clicked: () => switchkeyboardLayout(),
    child: Widget.Label({
      setup: async (self) => {
        self.hook(
          hyprland,
          async (label, _kbName, layoutName) => {
            console.log(_kbName, layoutName);
            if (layoutName === undefined) {
              layoutName = await getCurrentKeyboardLayout();
            }
            console.log(layoutName);
            label.label = formatKeyboardLayout(layoutName);
          },
          "keyboard-layout"
        );
      },
    }),
  });
}

export default KeyboardLayout;
