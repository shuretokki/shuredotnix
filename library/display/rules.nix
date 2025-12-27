{
  windowrulev2 = [
    # Floating rules
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
  ];

  layerrule = [
    "match:namespace vicinae, blur on"
    "match:namespace vicinae, ignore_alpha 0"
    "match:namespace vicinae, no_anim on"
    "blur, waybar"
    "ignorealpha 0.2, waybar"
  ];
}