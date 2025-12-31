# https://github.com/vicinaehq/vicinae
{ config, lib, pkgs, vars, inputs, ... }:
let
  settingsJson = builtins.toJSON {
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
    extensions = {};
  };

  extensionPrefs = {
    "@sovereign/store.vicinae.awww-switcher:data" = {
      wallpaperPath = "${config.home.homeDirectory}/${vars.wallpaperDir}";
      gridRows = "4";
      transitionType = "random";
      transitionDuration = "1";
    };
  };
in {
  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
    settings = null;
  };

  home.file.".config/vicinae/settings.json" = {
    text = settingsJson;
    force = true;
  };

  home.packages = with pkgs; [ sqlite ];

  home.activation.vicinaePreferences = lib.hm.dag.entryAfter ["writeBoundary"] ''
    VICINAE_DB="$HOME/.local/share/vicinae/vicinae.db"

    if [ -f "$VICINAE_DB" ]; then
      ${pkgs.sqlite}/bin/sqlite3 "$VICINAE_DB" << 'EOF'
        INSERT OR REPLACE INTO storage_data_item (namespace_id, value_type, key, value)
        VALUES
          ('@sovereign/store.vicinae.awww-switcher:data', 1, 'wallpaperPath', '${config.home.homeDirectory}/${vars.wallpaperDir}'),
          ('@sovereign/store.vicinae.awww-switcher:data', 1, 'gridRows', '4'),
          ('@sovereign/store.vicinae.awww-switcher:data', 1, 'transitionType', 'random'),
          ('@sovereign/store.vicinae.awww-switcher:data', 1, 'transitionDuration', '1');
EOF
      echo "Injected Vicinae extension preferences"
    fi
  '';
}
