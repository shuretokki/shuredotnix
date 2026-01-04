# https://github.com/vicinaehq/vicinae
# https://docs.vicinae.com/nixos
{
  config,
  lib,
  pkgs,
  vars,
  inputs,
  ...
}:
{
  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };

    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      awww-switcher
      pulseaudio
      power-profile
      wifi-commander
      bluetooth
      process-manager
      nix
      ssh
      hypr-keybinds
    ];

    themes = {
      sync = {
        meta = {
          version = 1;
          name = "Sync";
          description = "Sync with current theme";
          variant = config.theme.polarity;
          inherits = if config.theme.polarity == "dark" then "vicinae-dark" else "vicinae-light";
        };

        colors = let
          c = config.lib.stylix.colors.withHashtag;
        in {
          core = {
            background = c.base00;
            foreground = c.base05;
            secondary_background = c.base01;
            border = c.base02;
            accent = c.base0D;
          };
          accents = {
            blue = c.base0D;
            green = c.base0B;
            magenta = c.base0F;
            orange = c.base09;
            purple = c.base0E;
            red = c.base08;
            yellow = c.base0A;
            cyan = c.base0C;
          };
        };
      };
    };

    settings = {
      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      favicon_service = "twenty";
      search_files_in_root = true;
      use_layer_shell = true;
      font = {
        normal = {
          size = 10.5;
          normal = config.theme.fonts.sans;
        };
      };
      theme = {
        light = {
          name = "sync";
          icon_theme = "default";
        };
        dark = {
          name = "sync";
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
            wallpaperPath = "${config.home.homeDirectory}/.local/share/awww";
            colorGenTool = "none"; # this settings crash with our color scheme so better be disabled
            # Customization ..
            gridRows = "4"; # 3|4|5|6
            showImageDetails = true;
            transitionType = "none"; # none|simple|fade|left|right|top|bottom|wipe|wave|grow|center|any|outer|random
            transitionDuration = "1"; # 8|5|3|2|1 (seconds)
            transitionStep = "90"; # 1|45|90|120|200|255 (color steps)
            transitionFPS = "60";
            toggleVicinaeSetting = false; # Close vicinae after selecting wallpaper
            postProduction = "no"; # no|grayscale|grayscaleblur|grayscaleheavyblur|lightblur|lightblurdarken|heavyblur|heavyblurdarken|negate
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
        "@leonkohli/process-manager-0" = {
          preferences = {
            refresh-interval = "7000";
            sort-by-memory = true;
            show-system-processes = true;
            show-pid = true;
            show-path = false;
            search-in-paths = true;
            search-in-pid = true;
            close-window-after-kill = false;
            clear-search-after-kill = false;
            process-limit = "200";
          };
        };
      };
    };
  };

  xdg.configFile."vicinae/settings.json" = {
    force = true;
    text = builtins.toJSON config.programs.vicinae.settings;
  };
}
