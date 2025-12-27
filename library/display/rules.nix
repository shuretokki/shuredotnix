# https://wiki.hypr.land/Configuring/Window-Rules/
{
  windowrulev2 = [
    "float, class:^(pavucontrol)$"
    "float, class:^(blueman-manager)$"
    "float, class:^(nm-connection-editor)$"
    "float, class:^(localsend_app)$"
    "float, class:^(org.gnome.Nautilus)$"
    "float, title:^(About)(.*)$"
    "float, class:^(xdg-desktop-portal-gtk)$"

    "size 800 600, class:^(localsend_app)$"
    "center, class:^(localsend_app)$"

    "opacity 0.95, class:^(warp-terminal)$"
    "opacity 0.9, class:^(Spotify)$"

    "workspace 5, class:^(Spotify)$"
    "workspace 4, class:^(localsend_app)$"
    "workspace 3, class:^(discord)$"

    "idleinhibit focus, class:^(mpv)$"
    "idleinhibit fullscreen, class:^(firefox)$"
    "idleinhibit fullscreen, class:^(zen)$"

    "opacity 1.0 override, class:^(xwayland)$"
  ];

  layerrule = [
    "match:namespace vicinae, blur on"
    "match:namespace vicinae, ignore_alpha 0"
    "match:namespace vicinae, no_anim on"
    "match:namespace waybar, blur on"
    "match:namespace waybar, ignore_alpha 0.2"
  ];
}