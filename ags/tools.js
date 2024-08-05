import { getScriptPath } from "./options.js";

export function execScript(name) {
  return Utils.execAsync(getScriptPath(name)).catch(console.error);
}

export function switchkeyboardLayout() {
  return execScript("switch_keyboard_layout.sh");
}
