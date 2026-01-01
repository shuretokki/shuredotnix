{ lib, pkgs, config, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  colors = config.lib.stylix.colors.withHashtag;

  ytmTheme = pkgs.writeText "stylix-ytm.css" ''
    :root {
      --ytmusic-background: ${colors.base00} !important;
      --ytmusic-background-solid: ${colors.base00} !important;
      --ytmusic-nav-bar: ${colors.base00} !important;
      --ytmusic-player-bar-background: ${colors.base00} !important;
      --ytmusic-color-black1: ${colors.base00} !important;
      --ytmusic-color-black2: ${colors.base00} !important;
      --ytmusic-color-black3: ${colors.base01} !important;
      --ytmusic-color-black4: ${colors.base01} !important;
      --ytmusic-general-background-a: ${colors.base00} !important;
      --ytmusic-general-background-b: ${colors.base00} !important;
      --ytmusic-general-background-c: ${colors.base00} !important;

      --ytmusic-text-primary: ${colors.base05};
      --ytmusic-text-secondary: ${colors.base04};
      --ytmusic-text-disabled: ${colors.base03};
      --ytmusic-color-white1: ${colors.base05};

      --ytmusic-selected-button-color: ${colors.base0D};
      --yt-spec-call-to-action: ${colors.base0D};
      --yt-spec-static-overlay-button-primary: ${colors.base0D};
    }

    ytmusic-app-layout,
    ytmusic-browse-response,
    ytmusic-detail-header-renderer,
    ytmusic-player-bar,
    ytmusic-nav-bar,
    ytmusic-guide-renderer,
    ytmusic-pivot-bar-renderer,
    tp-yt-paper-listbox,
    ytmusic-menu-popup-renderer,
    ytmusic-player-queue,
    #layout,
    #guide-wrapper,
    #contentContainer {
      background-color: ${colors.base00} !important;
    }

    ytmusic-search-box {
      background-color: ${colors.base00} !important;
    }
    ytmusic-search-box #input {
      background-color: ${colors.base01} !important;
      color: ${colors.base05} !important;
      border-radius: 20px !important;
    }

    ytmusic-responsive-list-item-renderer:hover,
    ytmusic-two-row-item-renderer:hover {
      background-color: ${colors.base01} !important;
    }

    ytmusic-chip-cloud-chip-renderer {
      background-color: ${colors.base01} !important;
    }

    .ytmusic-thumbnail-overlay-time-status-renderer,
    ytmusic-thumbnail-renderer img {
      border-radius: 8px !important;
    }

    ::-webkit-scrollbar { width: 8px; }
    ::-webkit-scrollbar-track { background: ${colors.base00}; }
    ::-webkit-scrollbar-thumb { background: ${colors.base02}; border-radius: 4px; }
    ::-webkit-scrollbar-thumb:hover { background: ${colors.base03}; }
  '';
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    inputs.youtube-music.homeManagerModules.default
  ];

  # YouTube Music
  # Docs: https://h-banii.github.io/youtube-music-nix/pages/home-manager/
  programs.youtube-music = {
    enable = true;
    options.themes = [ ytmTheme ];

    # Plugins - Uncomment to enable
    # Full list: https://github.com/th-ch/youtube-music/wiki/Plugins
    plugins = {
        # adblocker = { enable = true; };
        # album-actions = { enable = true; };
        # album-color-theme = { enable = true; };
        # ambient-mode = { enable = true; };
        # amuse = { enable = true; };
        # api-server = { enable = true; };
        # audio-compressor = { enable = true; };
        # auth-proxy-adapter = { enable = true; };
        # blur-nav-bar = { enable = true; };
        # bypass-age-restrictions = { enable = true; };
        # captions-selector = { enable = true; };
        # compact-sidebar = { enable = true; };
        # crossfade = { enable = true; };
        # custom-output-device = { enable = true; };
        # disable-autoplay = { enable = true; };
        # discord = { enable = true; };  # Rich Presence
        # downloader = { enable = true; };
        # equalizer = { enable = true; };
        # exponential-volume = { enable = true; };
        # in-app-menu = { enable = true; };
        # lumiastream = { enable = true; };
        # lyrics-genius = { enable = true; };
        # music-together = { enable = true; };
        # navigation = { enable = true; };
        # no-google-login = { enable = true; };
        # notifications = { enable = true; };
        # performance-improvement = { enable = true; };
        # picture-in-picture = { enable = true; };
        # playback-speed = { enable = true; };
        # precise-volume = { enable = true; };
        # quality-changer = { enable = true; };
        # scrobbler = { enable = true; };  # Last.fm
        # shortcuts = { enable = true; };
        # skip-disliked-songs = { enable = true; };
        # skip-silences = { enable = true; };
        # sponsorblock = { enable = true; };
        # synced-lyrics = { enable = true; };
        # taskbar-mediacontrol = { enable = true; };
        # touchbar = { enable = true; };
        # transparent-player = { enable = true; };
        # tuna-obs = { enable = true; };
        # unobtrusive-player = { enable = true; };
        # video-toggle = { enable = true; };
        # visualizer = { enable = true; };
    };
  };


  # Spicetify
  # https://gerg-l.github.io/spicetify-nix
  programs.spicetify = {
    enable = lib.mkDefault true;

    theme = {
      name = "stylix";
      src = pkgs.writeTextDir "color.ini" "";  # write color.ini since spicetify need it
      injectCss = true;
      replaceColors = true;
      overwriteAssets = false;
      sidebarConfig = false;
      additionalCss = builtins.readFile ./user.css;
    };

    # All available color scheme components
    # Reference: https://spicetify.app/docs/development/customization/#color-scheme
    customColorScheme = {
      # text
      text = colors.base05;  # main text, playlist names, headings
      subtext = colors.base04;  # secondary text, artist names

      # backgrounds
      main = colors.base00;  # main background
      sidebar = colors.base00;  # sidebar background
      player = colors.base00;  # player bar background
      card = colors.base01;  # popup cards, hover states
      shadow = colors.base00;  # shadows
      main-secondary = colors.base01;  # selected song rows, cards

      # buttons
      button = colors.base0D;  # primary buttons, like button
      button-secondary = colors.base04;  # download/options buttons
      button-active = colors.base0C;  # button hover state
      button-disabled = colors.base02;  # seekbar bg, volume bg, scrollbar

      # navigation
      nav-active-text = colors.base05;  # active nav item text
      nav-active = colors.base02;  # sidebar active button bg
      selected-row = colors.base02;  # selected row highlight
      tab-active = colors.base02;  # active tab background

      # playback
      play-button = colors.base0D;  # main play button color
      playback-bar = colors.base0D;  # seekbar fg, volume fg

      # notifications
      notification = colors.base01;  # notification background
      notification-error = colors.base08;  # error notification

      # misc
      misc = colors.base04;  # miscellaneous elements
    };

    # Extensions - Uncomment the ones you want to enable
    # Full docs: https://gerg-l.github.io/spicetify-nix/extensions.html
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
      adblock

      # -... Official Extensions
      # autoSkipExplicit
      # autoSkipVideo
      # bookmark
      # keyboardShortcut
      # loopyLoop
      # popupLyrics
      # trashbin
      # webnowplaying

      # -... Community Extensions
      # groupSession
      # powerBar
      # seekSong
      # skipOrPlayLikedSongs
      # playlistIcons
      # fullAlbumDate
      # fullAppDisplayMod
      # goToSong
      # listPlaylistsWithSong
      # playlistIntersection
      # skipStats
      # phraseToPlaylist
      # wikify
      # writeify
      # formatColors
      # featureShuffle
      # oldSidebar
      # songStats
      # autoVolume
      # showQueueDuration
      # copyToClipboard
      # volumeProfiles
      # history
      # betterGenres
      # lastfm
      # savePlaylists
      # autoSkip
      # fullScreen
      # playNext
      # volumePercentage
      # copyLyrics
      # playingSource
      # sectionMarker
      # skipAfterTimestamp
      # beautifulLyrics
      # addToQueueTop
      # oneko
      # starRatings
      # queueTime
      # coverAmbience
      # sleepTimer
      # simpleBeautifulLyrics
      # allOfArtist
      # oldLikeButton
      # oldCoverClick
      # bestMoment
      # catJamSynced
      # aiBandBlocker
    ];

    enabledSnippets = [
      # "title": "Dynamic Search Bar",
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
          background-color: ${colors.base00};
        }
        .liw6Y_iPu2DJRwk10x9d .FLyfurPaIDAlwjsF3mLf {
          display: none;
        }
      ''
      # Add more snippets here as separate strings
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
