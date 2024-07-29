const audio = await Service.import("audio");

export function formatPercent(number) {
  return `${Math.round(number * 100)}%`;
}

const volumeIcons = Object.freeze({
  101: "overamplified",
  67: "high",
  34: "medium",
  1: "low",
  0: "muted",
});

/**
 * @param {number | null} volume
 * @returns current volume icon
 */
export function getVolumeIcon(volume = null) {
  let iconIndex;
  if (audio.speaker.is_muted) {
    iconIndex = 0;
  } else {
    const currentVolume = (volume ?? audio.speaker.volume ?? 0) * 100;
    iconIndex = [101, 67, 34, 1, 0].find(
      (threshold) => threshold <= currentVolume
    );
  }
  return `audio-volume-${volumeIcons[iconIndex ?? 0]}-symbolic`;
}

export function range(length, start = 1) {
  return Array.from({ length }, (_, i) => i + start);
}
