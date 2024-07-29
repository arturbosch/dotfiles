import Widget from "resource:///com/github/Aylur/ags/widget.js";

/**
 * @param {(toggled: boolean) => void} action
 * @param {any} icon Widget.Icon expected
 * @param {boolean} defaultToggleStatus
 */
function ToggleIconButton(
  action,
  icon,
  defaultToggleStatus = false,
  props = {}
) {
  let toggled = Variable(defaultToggleStatus);
  const onToggle = () => {
    toggled.setValue(!toggled.getValue());
    action(toggled.getValue());
  };

  return Widget.Button({
    class_name: "toggle-icon-button",
    on_clicked: onToggle,
    child: icon,
    ...props,
  });
}

export default ToggleIconButton;
