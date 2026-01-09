# https://wiki.hypr.land/Configuring/Keywords/#exec-once
{ pkgs, ... }: {
  exec-once = [
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

    "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    "${pkgs.vicinae}/bin/vicinae daemon"

    "wl-paste --type image --watch cliphist store"
    "wl-paste --type text --watch cliphist store"

    "hyprctl setcursor macOS 24"
    "hyprsunset"

    "swayosd-server"
    "swww-daemon"
    "fcitx5 -d"
  ];
}
