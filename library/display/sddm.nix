{ config, lib, pkgs, ... }:
let
  cfg = config.shure.display.sddm;
  theme = pkgs.where-is-my-sddm-theme.override {
    themeConfig.General = {
      background = builtins.toString config.theme.wallpaper;
      backgroundMode = "fill"; # none, fill, aspect, cover
    };
  };
in
{
  options.shure.display.sddm = {
    enable = lib.mkEnableOption "SDDM display manager with Wayland";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
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
