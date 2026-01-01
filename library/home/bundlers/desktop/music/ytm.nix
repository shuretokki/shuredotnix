{ lib, pkgs, config, inputs, ... }:
let
  colors = config.lib.stylix.colors.withHashtag;

  colorOverrides = ''
    html:not(.style-scope) {
      --ytm-accent: ${colors.base0D};

      --ytm-text: ${colors.base05};
      --ytm-subtext1: ${colors.base04};
      --ytm-subtext0: ${colors.base04};

      --ytm-overlay2: ${colors.base03};
      --ytm-overlay1: ${colors.base03};
      --ytm-overlay0: ${colors.base02};
      --ytm-surface2: ${colors.base02};
      --ytm-surface1: ${colors.base01};
      --ytm-surface0: ${colors.base01};
      --ytm-base: ${colors.base00};
      --ytm-mantle: ${colors.base00};
      --ytm-crust: ${colors.base00};
    }
  '';

  ytmTheme = pkgs.writeText "ytm-stylix.css" (colorOverrides + builtins.readFile ./ytm.css);
in {
  imports = [ inputs.youtube-music.homeManagerModules.default ];

  # YouTube Music
  # See more: https://h-banii.github.io/youtube-music-nix/pages/home-manager/
  programs.youtube-music = {
    enable = true;
    options.themes = [ ytmTheme ];

    # Plugins
    # See more: https://github.com/th-ch/youtube-music/wiki/Plugins
    plugins = {
        # adblocker = { enable = true; };
        # album-actions = { enable = true; };
        # notifications = { enable = true; };
        # shortcuts = { enable = true; };
        # sponsorblock = { enable = true; };
        # touchbar = { enable = true; };
        # t-visualizer = { enable = true; };
    };
  };
}
