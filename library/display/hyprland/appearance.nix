# https://wiki.hypr.land/Configuring/Variables/
{ config, ... }:
let
  colors = config.lib.stylix.colors;
in {
  general = {
    gaps_in = config.theme.hyprland.gaps-in;
    gaps_out = config.theme.hyprland.gaps-out;
    border_size = 2;
    "col.active_border" = config.theme.hyprland.active-border-col;
    "col.inactive_border" = config.theme.hyprland.inactive-border-col;
    # layout = "dwindle";
  };

  decoration = {
    rounding = config.theme.hyprland.rounding;
    blur = {
        enabled = config.theme.hyprland.blur;
        size = 5;
        passes = 3;
        new_optimizations = true;
        ignore_opacity = true;
        xray = false;
    };
    shadow = {
        enabled = config.theme.hyprland.shadows;
        range = 15;
        render_power = 3;
        color = "0x55000000";
    };
  };

  dwindle = {
    # single_window_aspect_ratio = "1 1"; # Uncomment if needed
  };

  # https://wiki.hypr.land/Configuring/Animations/
  animations = {
    enabled = true;

    bezier = [
      "f, 0.05, 0.9, 0.1, 1"
      "md3_standard, 0.2, 0, 0, 1"
      "md3_decel, 0.05, 0.7, 0.1, 1"
      "md3_accel, 0.3, 0, 0.8, 0.15"
      "overshot, 0.05, 0.9, 0.1, 1.1"
      "crazy, 0.1, 1.5, 0.76, 0.92"
      "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
      "menu_decel, 0.1, 1, 0, 1"
      "menu_accel, 0.38, 0.04, 1, 0.07"
      "easeInOutCircle, 0.85, 0, 0.15, 1"
      "easeOutQuart, 0.25, 1, 0.5, 1"
      "easeOutExpo, 0.16, 1, 0.3, 1"
      "softAcDecel, 0.26, 0.26, 0.15, 1"
      "md2, 0.4, 0, 0.2, 1"
    ];

    animation = [
      "windows, 1, 3, md3_decel, popin 60%"
      "windowsIn, 1, 3, md3_decel, popin 60%"
      "windowsOut, 1, 3, md3_accel, popin 60%"
      "border, 1, 10, default"
      "fade, 1, 3, md3_decel"
      "layers, 1, 2, md3_decel, slide"
      "layersIn, 1, 3, menu_decel, slide"
      "layersOut, 1, 3, menu_accel, slide"
      "fadeLayersIn, 1, 2, menu_decel"
      "fadeLayersOut, 1, 3, menu_accel"
      "workspaces, 1, 7, menu_decel, slide"
      "workspaces, 1, 2.5, softAcDecel, slide"
      "specialWorkspace, 1, 3, md3_decel, slidevert"
    ];
  };

  plugin = {
    hyprbars = {
      bar_height = 24;
      bar_part_of_window = true;
      bar_title_enabled = true;
      bar_precedence_over_border = true;
      bar_buttons_alignment = "left";
      bar_color = "rgba(${colors.base00}ff)";
      bar_blur = "on";
      bar_padding = 12;
      bar_button_padding = 9;

      "hyprbars-button" = [
        "rgb(${colors.base08}), 13, , hyprctl dispatch killactive"
        "rgb(${colors.base0A}), 13, , hyprctl dispatch fullscreen 1"
      ];
    };
  };

  misc = {
    vfr = true;
    vrr = 1;
    focus_on_activate = true;
    animate_manual_resizes = true;
    animate_mouse_windowdragging = true;
    enable_swallow = true;
    swallow_regex = "^(warp-terminal)$";
    disable_hyprland_logo = true;
    force_default_wallpaper = 0;
    allow_session_lock_restore = true;
    initial_workspace_tracking = false;
  };

  cursor = {
    no_hardware_cursors = true;
    enable_hyprcursor = true;
    warp_on_change_workspace = true;
  };
}