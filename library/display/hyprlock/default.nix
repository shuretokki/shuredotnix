{ config, pkgs, lib, vars, ... }:
let
  colors = config.lib.stylix.colors;
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading = true;
        hide_cursor = true;
      };

      background = lib.mkForce [
        {
          monitor = "";
          path = "screenshot";
          color = "rgba(${colors.base00}ff)";
          blur_passes = 1;
        }
      ];

      input-field = lib.mkForce [
        {
          monitor = "";
          size = config.theme.hyprlock.input-field.size;
          outline_thickness = config.theme.hyprlock.input-field.outline_thickness;
          dots_size = config.theme.hyprlock.input-field.dots_size;
          dots_spacing = config.theme.hyprlock.input-field.dots_spacing;
          dots_center = true;
          outer_color = "rgba(${colors.base0D}ff)";
          inner_color = "rgba(${colors.base00}ff)";
          font_color = "rgba(${colors.base05}ff)";
          fade_on_empty = false;
          placeholder_text = "<i>Password...</i>";
          hide_input = false;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      label = lib.mkForce [
        {
          monitor = "";
          text = "$TIME";
          color = "rgba(${colors.base05}ff)";
          font_size = config.theme.hyprlock.fontSize;
          font_family = config.theme.hyprlock.fontFamily;
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
