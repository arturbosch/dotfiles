import icons from "../../icons.js";
import { todoTxtFile } from "../../options.js";

function TodoTxtWidget() {
  const entries = Variable([]);
  async function updateEntries() {
    const content = await Utils.readFileAsync(todoTxtFile);
    // @ts-ignore
    entries.setValue(content.trim().split("\n"));
  }
  Utils.monitorFile(todoTxtFile, updateEntries);

  const menu = Widget.Menu({
    children: entries.bind().as((vals) =>
      vals.map((val) =>
        Widget.MenuItem({
          child: Widget.Label(val),
        })
      )
    ),
    focusOnClick: true,
  });

  return Widget.Button({
    setup: (_self) => {
      updateEntries();
    },
    on_primary_click: (_, event) => {
      menu.popup_at_pointer(event);
    },
    on_secondary_click: () => {
      Utils.execAsync("gnome-text-editor " + todoTxtFile);
    },
    child: Widget.Box({
      spacing: 8,
      children: [
        Widget.Icon({ icon: icons.todoTxt }),
        Widget.Label({
          label: entries.bind().as((vals) => vals.length.toString()),
        }),
      ],
    }),
  });
}

export default TodoTxtWidget;
