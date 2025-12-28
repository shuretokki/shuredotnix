# https://wiki.hypr.land/Configuring/Keywords/#exec-once
{ pkgs, ... }: {
  exec-once = [
    "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    "${pkgs.vicinae}/bin/vicinae daemon"

    "wl-paste --type image --watch cliphist store"
    "wl-paste --type text --watch cliphist store"

    "hyprctl setcursor macOS 24"
    "hyprsunset"

    "swayosd-server"
    "fcitx5 -d"
  ];
}
