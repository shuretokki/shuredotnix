{ lib, pkgs, config, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  colorsRaw = config.lib.stylix.colors;
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  # Spicetify
  # https://gerg-l.github.io/spicetify-nix
  programs.spicetify = {
    enable = lib.mkDefault true;

    theme = {
      name = "stylix";
      src = pkgs.writeTextDir "color.ini" ""; # write empty color.ini since spicetify expects it
      injectCss = true;
      replaceColors = true;
      overwriteAssets = false;
      sidebarConfig = false;
      additionalCss = builtins.readFile ./spicetify.css;
    };

    # All available color scheme components
    # Reference: https://spicetify.app/docs/development/customization/#color-scheme
    # NOTE: Uses colorsRaw (no #) since Spicetify expects raw hex values
    customColorScheme = {
      text = colorsRaw.base05;
      subtext = colorsRaw.base04;

      main = colorsRaw.base00; # main background
      sidebar = colorsRaw.base00; # sidebar background
      player = colorsRaw.base00; # player bar background
      card = colorsRaw.base01; # popup cards
      shadow = colorsRaw.base00;
      main-secondary = colorsRaw.base01; # selected song rows

      button = colorsRaw.base0D;
      button-secondary = colorsRaw.base04; # download/options buttons
      button-active = colorsRaw.base0C; # button hover state
      button-disabled = colorsRaw.base02;

      nav-active-text = colorsRaw.base05;
      nav-active = colorsRaw.base02; # sidebar active button bg
      selected-row = colorsRaw.base02; # selected row highlight
      tab-active = colorsRaw.base02; # active tab background

      play-button = colorsRaw.base0D;
      playback-bar = colorsRaw.base0D; # seekbar fg, volume fg

      notification = colorsRaw.base01; # notification background
      notification-error = colorsRaw.base08;

      # small icons, separators, dividers, hover highlights, and other
      # ui elements not covered by specific color categories
      misc = colorsRaw.base04;
    };

    # Extensions
    # See more: https://gerg-l.github.io/spicetify-nix/extensions.html
    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      hidePodcasts
      adblock
      fullScreen
    ];

    # Snippets
    # See more: https://gerg-l.github.io/spicetify-nix/snippets.html
    enabledSnippets = [
      # "title": "Dynamic Search Bar",
      # "description": "Make the search bar dynamic, so it only shows when you hover over it.",
      # "state": "Modded",
      ''
        :root {
          margin-top: -16px;
        }
        #global-nav-bar {
          position: absolute;
          width: calc(100% + 16px);
          background: none;
          opacity: 0;
          z-index: 12;
          top: 16px;
          transition: opacity 0.3s ease-in-out;
        }
        #global-nav-bar:hover {
          background: ${colorsRaw.base00};
          z-index: 12;
          opacity: 1;
        }
        .Root__now-playing-bar {
          transform: translateY(16px);
        }
        aside[aria-label="Now playing bar"] {
          transform: translateY(-8px);
        }
        .Root__globalNav .main-globalNav-navLink {
          background: none;
        }
        .e_N7UqrrJQ0fAw9IkNAL {
          padding-top: 56px;
        }
        .marketplace-tabBar, .marketplace-tabBar-nav {
          padding-top: 48px;
        }
        .marketplace-header {
          padding-top: 16px;
        }
        .marketplace-header__left {
          padding-top: 16px;
        }
        .main-topBar-background {
          background-color: ${colorsRaw.base00};
        }
        .liw6Y_iPu2DJRwk10x9d .FLyfurPaIDAlwjsF3mLf {
          display: none;
        }
      ''

      # "title": "Modern ScrollBar",
      # "description": "Thin rounded modern scrollbar",
      # "state": "Original",
      ''
        .os-scrollbar-handle {
          width: 0.25rem !important;
          border-radius: 10rem !important;
          transition: width 300ms ease-in-out;
        }
        .os-scrollbar-handle:focus,
        .os-scrollbar-handle:focus-within,
        .os-scrollbar-handle:hover {
          width: 0.35rem !important;
        }
      ''

      # add more here ...
      # "title": "",
      # "description": "",
      # "state": "",
      ''
      ''

    ];
  };

  home.packages = with pkgs; [
    (writeShellScriptBin "spotify-th" ''
      exec env -u QT_QPA_PLATFORMTHEME ${config.programs.spicetify.spicetifyPackage}/bin/spotify --no-zygote "$@"
    '')
  ];

  xdg.desktopEntries.spotify = {
    name = "Spotify";
    genericName = "Music Player";
    exec = "spotify-th %U";
    icon = "spotify-client";
    terminal = false;
    categories = [ "Audio" "Music" "Player" "AudioVideo" ];
    mimeType = [ "x-scheme-handler/spotify" ];
  };
}
