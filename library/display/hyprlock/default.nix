{ config, pkgs, ... }:
let
  theme = import ./themes/current.nix;
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading = true;
        hide_cursor = true;
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          color = "rgba(${theme.colors.bg}ff)";
          blur_passes = 3;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "300, 50";
          outline_thickness = 2;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          outer_color = "rgba(${theme.colors.active_border}ff)";
          inner_color = "rgba(${theme.colors.bg}ff)";
          font_color = "rgba(${theme.colors.fg}ff)";
          fade_on_empty = false;
          placeholder_text = "<i>Password...</i>";
          hide_input = false;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "rgba(${theme.colors.fg}ff)";
          font_size = 64;
          font_family = "SF Pro Rounded";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
