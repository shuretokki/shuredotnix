{ lib, pkgs, config, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  colors = config.lib.stylix.colors.withHashtag;

  ytmTheme = pkgs.writeText "stylix-ytm.css" ''
    :root {
      --ytmusic-background: ${colors.base01};
      --ytmusic-background-solid: ${colors.base01};
      --ytmusic-nav-bar: ${colors.base01};
      --ytmusic-player-bar-background: ${colors.base01};
      --ytmusic-color-black1: ${colors.base01};
      --ytmusic-color-black2: ${colors.base01};
      --ytmusic-color-black3: ${colors.base02};
      --ytmusic-color-black4: ${colors.base03};

      --ytmusic-text-primary: ${colors.base05};
      --ytmusic-text-secondary: ${colors.base04};
      --ytmusic-text-disabled: ${colors.base03};
      --ytmusic-color-white1: ${colors.base05};

      --ytmusic-general-background-a: ${colors.base01};
      --ytmusic-selected-button-color: ${colors.base0D};
      --yt-spec-static-overlay-button-primary: ${colors.base0D};
      --yt-spec-call-to-action: ${colors.base0D};
      --paper-toggle-button-checked-button-color: ${colors.base0D};
      --paper-toggle-button-checked-bar-color: ${colors.base0C};
    }

    ytmusic-app,
    ytmusic-browse-response,
    ytmusic-two-row-item-renderer,
    ytmusic-responsive-list-item-renderer,
    ytmusic-player-bar,
    ytmusic-nav-bar,
    ytmusic-guide-section-renderer,
    ytmusic-guide-entry-renderer,
    tp-yt-paper-listbox,
    ytmusic-menu-popup-renderer,
    ytmusic-search-box,
    ytmusic-multi-select-menu-renderer,
    ytmusic-player-queue,
    ytmusic-tab-renderer,
    #contentContainer {
      background-color: ${colors.base01} !important;
    }

    ytmusic-guide-renderer,
    #guide-wrapper,
    #layout {
      background-color: ${colors.base01} !important;
    }

    ytmusic-search-box #input {
      background-color: ${colors.base02} !important;
      color: ${colors.base05} !important;
    }

    ytmusic-responsive-list-item-renderer:hover {
      background-color: ${colors.base02} !important;
    }

    yt-button-renderer {
      --yt-button-color: ${colors.base0D};
    }

    img.ytmusic-player-bar,
    .thumbnail-image-wrapper img,
    ytmusic-thumbnail-with-lyrics-renderer img,
    .ytmusic-carousel img {
      border-radius: 8px !important;
    }
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
      name = "user";
      src = pkgs.writeTextDir "color.ini" "";
      injectCss = true;
      replaceColors = true;
      overwriteAssets = false;
      sidebarConfig = false;

      additionalCss = ''
        /* round now Playing Bar */
        :root {
          --border-radius-1: 8px;
          --margin-bottom-now-playing-bar: 0.5rem;
          --now-playing-bar-height: 5.625rem;
          --padding-now-playing-bar: 0.25rem;
          --border-radius-now-playing-bar: 0.5rem;
        }

        .Root__now-playing-bar,
        .Root__now-playing-bar footer,
        .Root__right-sidebar,
        .UrfDp0_mKGL9hkfh9g_R {
          border-radius: 8px !important;
        }

        /* transparent window controls */
        #main::after {
          content: "";
          position: fixed;
          top: 0;
          right: 0;
          z-index: 999;
          backdrop-filter: brightness(2.12);
          width: 135px;
          height: 64px;
        }

        h1 { font-weight: 700 !important; }

        /* song/artist in player */
        .main-nowPlayingWidget-nowPlaying .main-trackInfo-name {
          overflow: unset;
          font-size: 20px !important;
        }
        .main-nowPlayingWidget-nowPlaying .main-trackInfo-artists {
          overflow: unset;
          font-size: 15px;
        }

        /* progress bar */
        .progress-bar { --fg-color: ${colors.base0D}; }
        .progress-bar__bg, .progress-bar__fg, .progress-bar__fg_wrapper { height: 5px; }

        /* top bar - use base02 */
        .main-topBar-background { background-color: ${colors.base02} !important; }

        /* scrollbars */
        .os-scrollbar-handle {
          background: ${colors.base0D} !important;
          border-radius: 8px;
        }
        .os-theme-spotify.os-host-transition > .os-scrollbar-vertical > .os-scrollbar-track > .os-scrollbar-handle {
          border-radius: 8px;
          width: 4px;
        }

        .cover-art-image,
        .view-homeShortcutsGrid-image { border-radius: 8px; }

        .main-entityHeader-shadow,
        .x-categoryCard-image,
        .main-cardImage-image,
        .main-cardImage-imageWrapper { border-radius: 8px; }

        .main-trackList-rowImage { border-radius: 4px; }

        /* player bar */
        .main-nowPlayingBar-container {
          justify-content: center;
          height: 5.625rem;
          width: 100%;
          border-radius: 8px;
          padding: 0.25rem;
          bottom: 0.5rem;
          background-color: ${colors.base01};
          backdrop-filter: blur(10px) saturate(0.5) brightness(100%);
        }

        /* home gradient */
        .main-home-homeHeader { background-color: ${colors.base0D} !important; }

        /* volume bar */
        .volume-bar .progress-bar { margin: 0 0.4rem; }
        .volume-bar { flex: 0 150px; }

        .playlist-playlist-actionBarBackground-background { visibility: hidden; }
      '';
    };

    colorScheme = lib.mkForce "custom";
    customColorScheme = {
      text = colors.base05;
      subtext = colors.base04;
      main = colors.base01;
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
