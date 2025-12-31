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
      player-pilot
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

      providers = {
        "@sovereign/awww-switcher-0" = {
          preferences = {
            wallpaperPath = "${config.home.homeDirectory}/${vars.wallpaperDir}";
            gridRows = "4";
            transitionType = "random";
            transitionDuration = "1";
          };
        };
        # "@sovereign/store.vicinae.awww-switcher" = {
        #   preferences = {
        #     wallpaperPath = "${config.home.homeDirectory}/${vars.wallpaperDir}";
        #     gridRows = "4";
        #     transitionType = "random";
        #     transitionDuration = "1";
        #   };
        # };
        "@rastsislaux/pulseaudio-0" = {
          preferences = {
            show_volume = true;
          };
        };
      };
    };
  };
}
