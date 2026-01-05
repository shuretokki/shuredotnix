{ config, pkgs, lib, vars, ... }:
let
  cfg = config.theme.waybar;
in {
  # Logic to handle waybar if enabled?
  # Assuming this module is imported when waybar is desired.

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # Disable HM generation of these files since we provide them manually
    settings = {};
    style = "";
  };

  # Direct file provisioning
  xdg.configFile = {
    "waybar/config.jsonc" = lib.mkIf (cfg.configFile != null) {
      source = cfg.configFile;
    };
    "waybar/style.css" = lib.mkIf (cfg.styleFile != null) {
      source = cfg.styleFile;
    };
  };
}
