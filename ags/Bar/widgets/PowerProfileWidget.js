const powerProfiles = await Service.import("powerprofiles");

/* interface PowerProfile {
    Profile: String,
    CpuDriver: String,
    PlatformDriver?: String,
    Driver: string
} */

function PowerProfileWidget() {
  const size = powerProfiles.profiles.length;
  function toggleProfile() {
    const active = powerProfiles.active_profile;
    const activeIndex =
      powerProfiles.profiles.findIndex(
        (profile) => profile.Profile === active
      ) ?? 0;
    const newIndex = (activeIndex + 1) % size;
    powerProfiles.active_profile =
      powerProfiles.profiles.find((_, index) => index === newIndex)?.Profile ??
      "balanced";
  }
  return Widget.Button({
    child: Widget.Icon({ icon: powerProfiles.bind("icon_name") }),
    on_clicked: toggleProfile,
    tooltip_text: powerProfiles.bind("active_profile"),
  });
}

export default PowerProfileWidget;
