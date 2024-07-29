import icons from "../icons.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

const Toggler = (action) =>
  Widget.Button({
    onPrimaryClickRelease: action,
    child: Widget.Icon(icons.pan.down),
  });

export default Toggler;
