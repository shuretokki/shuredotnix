# Vicinae Launcher Configuration
# Source: https://github.com/vicinaehq/vicinae
{ config, lib, pkgs, vars, inputs, ... }: {
  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };

    settings = {
      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      favicon_service = "twenty";
      search_files_in_root = true;
      font = {
        normal = {
          size = 10.5;
          normal = vars.fontSans;
        };
      };
      theme = {
        light = {
          name = "gruvbox-light";
          icon_theme = "default";
        };
        dark = {
          name = "gruvbox-dark";
          icon_theme = "default";
        };
      };
      launcher_window = {
        opacity = 0.88;
      };
      extensions = {
        awww-switcher = {
          wallpaperPath = "${config.home.homeDirectory}/${vars.wallpaperDir}";
          gridRows = "4";
          transitionType = "random";
          transitionDuration = "1";
        };
        pulseaudio = {
          show_volume = true;
        };
        power-profile = {};
        wifi-commander = {};
        bluetooth = {};
        process-manager = {};
        fuzzy-files = {};
        nix = {};
        player-pilot = {};
        ssh = {};
        hypr-keybinds = {};
      };
    };
  };
}

