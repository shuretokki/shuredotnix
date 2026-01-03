{ config, pkgs, vars, ... }:
let
  sugarDark = pkgs.sddm-sugar-dark.override {
    themeConfig.Background = "${config.theme.wallpaper}";
  };
in {
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = "weston";
    };

    autoNumlock = true;
    theme = "sugar-dark";

    settings = {
      Theme = {
        CursorTheme = config.theme.cursor.name;
        CursorSize = config.theme.cursor.size;
      };
    };

    # autoLogin = {
    #   relogin = false;
    # };

    package = pkgs.kdePackages.sddm;
    extraPackages = [ sugarDark ];
  };

  environment.systemPackages = [ sugarDark ];
}
