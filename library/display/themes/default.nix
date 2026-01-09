{ lib, pkgs, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.theme = {
    scheme = mkOption {
      type = types.path;
      description = "Path to base16 scheme yaml file";
      default = ./default/schemes/sh-dark.yaml;
    };

    polarity = mkOption {
      type = types.enum [ "dark" "light" ];
      default = "dark";
      description = "Theme polarity";
    };

    fonts = {
      serif = mkOption { type = types.str; default = "New York"; };
      sans = mkOption { type = types.str; default = "SF Pro Rounded"; };
      mono = mkOption { type = types.str; default = "JetBrainsMono Nerd Font"; };
      size = mkOption { type = types.int; default = 12; };
    };

    cursor = {
      name = mkOption { type = types.str; default = "macOS"; };
      size = mkOption { type = types.int; default = 24; };
    };

    wallpaper = mkOption {
      type = types.path;
      description = "Path to the main wallpaper image (stylix)";
      default = ./default/wallpapers/000.jpg;
    };

    wallpaperDir = mkOption {
      type = types.path;
      description = "Path to the wallpapers directory (for symlinks)";
      default = ./default/wallpapers;
    };

    grub = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable custom GRUB theming";
      };

      theme = mkOption {
        type = types.package;
        description = "GRUB theme package to use";
        default = pkgs.stdenv.mkDerivation {
          pname = "wuthering-grub-theme";
          version = "1.0";
          src = pkgs.fetchFromGitHub {
            owner = "vinceliuice";
            repo = "Wuthering-grub2-themes";
            rev = "ed3f8bcd292e7a0684f3c30f20939710d263a321";
            sha256 = "sha256-q9TLZTZI/giwKu8sCTluxvkBG5tyan7nFOqn4iGLnkA=";
          };
          installPhase = ''
            mkdir -p $out
            cp -a $src/common/*.pf2 $out/
            cp -a $src/config/theme-1080p.txt $out/theme.txt
            cp -a $src/backgrounds/background-jinxi.jpg $out/background.jpg
            cp -a $src/assets/assets-icons/icons-1080p $out/icons
            cp -a $src/assets/assets-other/other-1080p/*.png $out/
          '';
        };
      };
    };

    waybar = {
      styleFile = mkOption {
        type = types.nullOr types.path;
        default = ./default/waybar/style.css;
        description = "Path to style.css file";
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = ./default/waybar/config.jsonc;
        description = "Path to config.jsonc file";
      };
    };

    hyprland = {
      gaps-in = mkOption { type = types.int; default = 4; };
      gaps-out = mkOption { type = types.int; default = 4; };
      rounding = mkOption { type = types.int; default = 0; };
      blur = mkOption { type = types.bool; default = true; };
      shadows = mkOption { type = types.bool; default = true; };
      active-border-col = mkOption { type = types.str; default = "rgba(33ccffee) rgba(00ff99ee) 45deg"; };
      inactive-border-col = mkOption { type = types.str; default = "rgba(595959aa)"; };
    };

    hyprlock = {
      fontFamily = mkOption { type = types.str; default = "SF Pro Rounded"; };
      fontSize = mkOption { type = types.int; default = 64; };
      input-field = {
        size = mkOption { type = types.str; default = "300, 50"; };
        outline_thickness = mkOption { type = types.int; default = 2; };
        dots_size = mkOption { type = types.float; default = 0.33; };
        dots_spacing = mkOption { type = types.float; default = 0.15; };
      };
    };
  };
}
