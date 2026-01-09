# https://ferdium.org/
# https://search.nixos.org/packages?query=ferdium
# TODO: consider migrating to beeper (https://www.beeper.com/)

{ pkgs, lib, config, ... }:
let
  c = config.lib.stylix.colors;

  sync = ''
    :root {
      --base00: #${c.base00};
      --base01: #${c.base01};
      --base02: #${c.base02};
      --base03: #${c.base03};
      --base04: #${c.base04};
      --base05: #${c.base05};
      --base06: #${c.base06};
      --base07: #${c.base07};
      --base08: #${c.base08};
      --base09: #${c.base09};
      --base0A: #${c.base0A};
      --base0B: #${c.base0B};
      --base0C: #${c.base0C};
      --base0D: #${c.base0D};
      --base0E: #${c.base0E};
      --base0F: #${c.base0F};

      --bg: var(--base00);
      --fg: var(--base05);
      --accent: var(--base0D);
    }

    ::-webkit-scrollbar { width: 8px; background: var(--base00); }
    ::-webkit-scrollbar-thumb { background: var(--base02); border-radius: 4px; }
    body { background: var(--bg) !important; color: var(--fg) !important; }
    a { color: var(--accent) !important; }
  '';

  style = pkgs.writeText "sync.css" sync;
  services = [ "gmail" "whatsapp" ];

  settings = {
    darkMode = true;
    universalDarkMode = true;
    adaptableDarkMode = true;
    accentColor = "#${c.base00}";
    progressbarAccentColor = "#${c.base0D}";

    useHorizontalStyle = true;
    autohideMenuBar = true;
    enableSystemTray = true;
    runInBackground = true;
    confirmOnQuit = false;

    hideRecipesButton = true;
    hideSplitModeButton = true;
    hideWorkspacesButton = true;
    hideNotificationsButton = true;

    enableGPUAcceleration = true;
    hibernateOnStartup = true;

    sentry = false;
  };
in
{
  home.packages = [ pkgs.ferdium ];

  xdg.configFile."Ferdium/config/settings.json".text =
    builtins.toJSON settings;

  # injects stylix theme into ferdium service recipes.
  # runs after ferdium creates recipe folders on first service add.
  # both user.css and darkmode.css needed for complete theme coverage.
  home.activation.injectRecipeStyles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for service in ${lib.concatStringsSep " " services}; do
      if [ -f "$HOME/.config/Ferdium/recipes/$service/package.json" ]; then
        cp -f "${style}" "$HOME/.config/Ferdium/recipes/$service/user.css"
        cp -f "${style}" "$HOME/.config/Ferdium/recipes/$service/darkmode.css"
      fi
    done
  '';
}
