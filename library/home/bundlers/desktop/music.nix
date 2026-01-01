{ lib, pkgs, config, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  colors = config.lib.stylix.colors.withHashtag;
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    inputs.youtube-music.homeManagerModules.default
  ];

  # YouTube Music
  # Docs: https://h-banii.github.io/youtube-music-nix/pages/home-manager/
  programs.youtube-music = {
    enable = true;
    options.themes = [ "stylix-custom" ];

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

  xdg.configFile."youtube-music/themes/stylix-custom.css".text = ''
    :root {
      --ytmusic-color-black: ${colors.base00};
      --ytmusic-color-white: ${colors.base05};
      --ytmusic-brand-background-solid: ${colors.base00};
      --ytmusic-general-background-a: ${colors.base00};
      --ytmusic-general-background-c: ${colors.base01};
      --ytmusic-text-primary: ${colors.base05};
      --ytmusic-text-secondary: ${colors.base04};
      --ytmusic-static-brand-red: ${colors.base08};
      --ytmusic-overlay-background-brand: ${colors.base08};
      --ytmusic-menu-item-hover-background-color: ${colors.base02};

      --font-family: "${config.stylix.fonts.sansSerif.name}";
      --border-radius: 8px;
    }

    body {
      background-color: ${colors.base00} !important;
      font-family: var(--font-family) !important;
    }

    img, .image, .song-media-controls {
      border-radius: var(--border-radius) !important;
    }

    ytmusic-nav-bar { background-color: ${colors.base01} !important; }
    ytmusic-player-bar { background-color: ${colors.base01} !important; }

    ::-webkit-scrollbar { width: 8px; }
    ::-webkit-scrollbar-track { background: ${colors.base00}; }
    ::-webkit-scrollbar-thumb { background: ${colors.base03}; border-radius: 4px; }
    ::-webkit-scrollbar-thumb:hover { background: ${colors.base04}; }
  '';


  # Spicetify
  # https://gerg-l.github.io/spicetify-nix
  programs.spicetify = {
    enable = lib.mkDefault true;

    # https://github.com/spicetify/spicetify-themes/tree/master/SharkBlue
    theme = lib.mkDefault spicePkgs.themes.sharkBlue;
    colorScheme = lib.mkForce "custom";
    customColorScheme = {
      text = colors.base05;
      subtext = colors.base04;
      main = colors.base00;
      sidebar = colors.base01;
      player = colors.base01;
      card = colors.base02;
      shadow = colors.base00;
      selected-row = colors.base03;
      button = colors.base0D;
      button-active = colors.base0C;
      button-disabled = colors.base03;
      tab-active = colors.base0D;
      notification = colors.base0B;
      notification-error = colors.base08;
      misc = colors.base04;
    };

    # Extensions - Uncomment the ones you want to enable
    # Full docs: https://gerg-l.github.io/spicetify-nix/extensions.html
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
      adblock

      # ── Official Extensions ──
      # autoSkipExplicit
      # autoSkipVideo
      # bookmark
      # keyboardShortcut
      # loopyLoop
      # popupLyrics
      # trashbin
      # webnowplaying

      # ── Community Extensions ──
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
