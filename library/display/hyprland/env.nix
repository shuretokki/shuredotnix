# https://wiki.hypr.land/Configuring/Environment-variables/
{ pkgs, ... }: {
  env = [
    "XCURSOR_THEME,macOS"
    "XCURSOR_SIZE,24"
    "HYPRCURSOR_SIZE,24"
    "XCURSOR_PATH,${pkgs.apple-cursor}/share/icons"

    "GDK_BACKEND,wayland,x11,*"
    "QT_QPA_PLATFORM,wayland;xcb"
    "QT_STYLE_OVERRIDE,kvantum"
    "SDL_VIDEODRIVER,wayland"
    "MOZ_ENABLE_WAYLAND,1"
    "ELECTRON_OZONE_PLATFORM_HINT,wayland"
    "OZONE_PLATFORM,wayland"
    "XDG_SESSION_TYPE,wayland"
    "XDG_CURRENT_DESKTOP,Hyprland"
    "XDG_SESSION_DESKTOP,Hyprland"
  ];
}
