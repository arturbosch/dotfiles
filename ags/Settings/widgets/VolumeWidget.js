import { formatPercent, getVolumeIcon } from "../../utils.js";
import ToggleIconButton from "../../widgets/ToggleIconButton.js";

const audio = await Service.import("audio");

function Volume() {
  // const { muted, low, high, medium, overamplified } = icons.volume;

  const icon = Widget.Icon({
    icon: audio.speaker.bind("volume").as(getVolumeIcon),
  });

  const tooltipBinding = audio.speaker.bind("volume").as(formatPercent);

  const muteButton = ToggleIconButton(
    (toggled) => (audio.speaker.is_muted = toggled),
    icon,
    audio.speaker.is_muted ?? false,
    { tooltip_text: tooltipBinding }
  );

  const slider = Widget.Slider({
    hexpand: true,
    draw_value: false,
    on_change: ({ value }) => (audio.speaker.volume = value),
    value: audio.speaker.bind("volume"),
    tooltip_text: tooltipBinding,
  });

  return Widget.Box({
    class_name: "volume",
    css: "min-width: 180px",
    children: [muteButton, slider],
  });
}

export default Volume;
