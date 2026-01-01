# https://github.com/vicinaehq/vicinae
# https://docs.vicinae.com/nixos
{ config, lib, pkgs, vars, inputs, ... }: {
  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };

    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      awww-switcher
      pulseaudio
      power-profile
      wifi-commander
      bluetooth
      process-manager
      fuzzy-files
      nix
      ssh
      hypr-keybinds
    ];

    settings = {
      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      favicon_service = "twenty";
      search_files_in_root = true;
      font = {
        normal = {
          size = 10.5;
          normal = config.theme.fonts.sans;
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

      providers = {
        "@sovereign/awww-switcher-0" = {
          favorite = true;
          preferences = {
            # Required ..
            wallpaperPath = "${config.home.homeDirectory}/${vars.wallpaperDir}";
            colorGenTool = "none";  # none|matugen|pywal|wpgtk|schemer2|colorz|haishoku|wallust
            # Customization ..
            gridRows = "4";  # 3|4|5|6
            showImageDetails = true;
            transitionType = "none";  # none|simple|fade|left|right|top|bottom|wipe|wave|grow|center|any|outer|random
            transitionDuration = "1";   # 8|5|3|2|1 (seconds)
            transitionStep = "90";      # 1|45|90|120|200|255 (color steps)
            transitionFPS = "60";
            toggleVicinaeSetting = false;  # Close vicinae after selecting wallpaper
            postProduction = "no";        # no|grayscale|grayscaleblur|grayscaleheavyblur|lightblur|lightblurdarken|heavyblur|heavyblurdarken|negate
          };
        };
        "@sovereign/hypr-keybinds-0" = {
          favorite = true;
          preferences = {
            keybindsConfigPath = "${config.home.homeDirectory}/.config/hypr/hyprland.conf";
          };
        };
        "@rastsislaux/pulseaudio-0" = {
          favorite = true;
          preferences = {
            show_volume = true;
          };
        };
      };
    };
  };
}
