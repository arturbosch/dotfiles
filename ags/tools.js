import { getScriptPath } from "./options.js";

export function execScript(name) {
  return Utils.execAsync(getScriptPath(name));
}
