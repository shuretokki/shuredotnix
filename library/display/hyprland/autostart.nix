# https://wiki.hypr.land/Configuring/Keywords/#exec-once
{ pkgs, ... }: {
  exec-once = [
    "hyprctl setcursor macOS-Monterey 24"
    "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    "nm-applet --indicator"
    "fcitx5 -d"
    "${pkgs.vicinae}/bin/vicinae daemon"
    "hyprsunset"
    "swayosd-server"
    "wl-paste --type text --watch cliphist store"
    "wl-paste --type image --watch cliphist store"
  ];
}
