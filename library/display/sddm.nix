# https://wiki.nixos.org/wiki/SDDM
# https://search.nixos.org/options?query=services.displayManager.sddm

{ config, lib, pkgs, ... }:
let
  cfg = config.library.display.sddm;

  # where-is-my-sddm-theme is minimal and supports wallpaper config.
  # override injects theme settings at build time (not runtime).
  theme = pkgs.where-is-my-sddm-theme.override {
    themeConfig.General = {
      background = builtins.toString config.theme.wallpaper;
      backgroundMode = "fill"; # none|fill|aspect|cover
    };
  };
in
{
  options.library.display.sddm = {
    enable = lib.mkEnableOption "SDDM display manager with Wayland";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;

      # weston is lightweight and stable for login screen.
      # kwin works but is heavier and can have quirks as a greeter.
      wayland = {
        enable = true;
        compositor = "weston";
      };

      autoNumlock = true;
      theme = "where_is_my_sddm_theme";

      settings.Theme = {
        CursorTheme = config.theme.cursor.name;
        CursorSize = config.theme.cursor.size;
      };

      extraPackages = [ theme ];
    };

    environment.systemPackages = [ theme ];
  };
}
