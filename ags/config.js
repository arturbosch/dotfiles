import Bar from "./Bar/Bar.js";
import { applauncher } from "./Launcher/Launcher.js";
import { monitors } from "./options.js";
import Settings from "./Settings/Settings.js";

const windows = [applauncher];

const bars = monitors.map((monitor) => Bar(monitor));
const settings = monitors.map((monitor) => Settings(monitor));

windows.push(...bars, ...settings);

App.config({
  style: "./style.css",
  windows,
  closeWindowDelay: {
    applauncher: 100,
  },
});

export {};
