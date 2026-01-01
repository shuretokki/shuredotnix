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
      name = "user";
      src = pkgs.writeTextDir "color.ini" "";
      injectCss = true;
      replaceColors = true;
      overwriteAssets = false;
      sidebarConfig = false;

      additionalCss = ''
        :root {
          --scroll: 0 !important;
        }

        .main-rootlist-rootlistDividerGradient {
          background: unset;
        }

        .x-searchInput-searchInputSearchIcon,
        .x-searchInput-searchInputClearButton {
          color: var(--spice-text) !important;
        }

        .main-home-homeHeader,
        .x-entityHeader-overlay,
        .x-actionBarBackground-background,
        .main-actionBarBackground-background,
        .main-entityHeader-overlay,
        .main-entityHeader-backgroundColor {
          background-color: unset !important;
          background-image: unset !important;
        }

        .main-playButton-PlayButton.main-playButton-primary {
          color: white;
        }

        .connect-device-list {
          margin: 0px -5px;
        }

        .main-topBar-background {
          background-color: ${colors.base00} !important;
        }
        .main-topBar-overlay {
          background-color: var(--spice-main);
        }

        .main-entityHeader-shadow,
        .main-contextMenu-menu,
        .connect-device-list-container {
          box-shadow: 0 4px 20px #21212130;
        }

        .main-trackList-playingIcon {
          filter: grayscale(1);
        }

        span.artist-artistVerifiedBadge-badge svg:nth-child(1) {
          fill: ${colors.base00};
        }

        .main-rootlist-rootlistItemLink.main-rootlist-rootlistItemLinkActive {
          background: var(--spice-button) !important;
          border-radius: 4px;
          padding: 0 10px;
          margin: 0 5px 0 -10px;
        }

        .main-navBar-navBarLinkActive {
          background: var(--spice-button);
          color: white;
        }

        .main-contextMenu-menu {
          background-color: var(--spice-misc) !important;
        }

        .main-contextMenu-menuHeading,
        .main-contextMenu-menuItemButton,
        .main-contextMenu-menuItemButton:not(.main-contextMenu-disabled):focus,
        .main-contextMenu-menuItemButton:not(.main-contextMenu-disabled):hover {
          color: var(--spice-text);
        }

        .main-playPauseButton-button {
          background-color: var(--spice-button);
          color: ${colors.base00};
        }

        /* queue page header */
        .queue-queue-title,
        .queue-playHistory-title {
          color: var(--spice-text) !important;
        }

        /* cards */
        .main-cardImage-imageWrapper {
          background-color: transparent;
        }

        .main-rootlist-rootlistDivider {
          background-color: unset;
        }

        .main-nowPlayingBar-nowPlayingBar {
          height: var(--player-bar-height);
        }

        input {
          background-color: var(--spice-misc);
          color: var(--spice-text) !important;
        }

        /* profile icon */
        .main-entityHeader-imagePlaceholder {
          color: unset;
        }

        /* left menu create playlist, liked songs and episodes button background */
        a.main-collectionLinkButton-collectionLinkButton.main-collectionLinkButton-selected.active,
        .main-createPlaylistButton-button:hover {
          background-color: var(--spice-button) !important;
        }

        /* experimental features background */
        .main-trackCreditsModal-container {
          background-color: var(--spice-misc) !important;
        }

        /* device showing menu */
        .main-connectBar-connectBar.mVVxN9ZfIRjiQfDuzPCZ {
          background-color: var(--spice-button) !important;
          color: var(--text-base);
        }

        :root {
          --lyrics-text-direction: left;
        }

        .main-lyricsCinema-controls {
          top: 80px !important;
        }

        #lyrics-backdrop,
        #lyrics-backdrop-container {
          position: absolute;
          width: 100%;
          height: 100%;
          background-color: ${colors.base00} !important;
        }

        .lyrics-lyrics-background {
          visibility: hidden !important;
        }

        .lyrics-lyricsContent-lyric:hover {
          color: var(--lyrics-color-active) !important;
        }

        .lyrics-lyricsContent-active {
          text-shadow: 0 0 15px rgba(255, 255, 255, 0.6);
        }

        /* scrollbar hide */
        .os-scrollbar.os-scrollbar-handle-interactive .os-scrollbar-handle,
        .os-scrollbar.os-scrollbar-track-interactive .os-scrollbar-track {
          width: 0 !important;
        }

        /* black gradient */
        .XVz4BMGP5zAEE5p90mYK {
          --background-base: ${colors.base00} !important;
          --background-base-min-contrast: ${colors.base00} !important;
        }

        .Bdcf5g__Rug3TGqSdbiy {
          --background-base-70: ${colors.base00} !important;
        }

        /* white text instead of accented color */
        .encore-internal-color-text-subdued {
          color: ${colors.base05};
        }

        /* Rounded images */
        .cover-art-image,
        .view-homeShortcutsGrid-image,
        .main-entityHeader-shadow,
        .x-categoryCard-image,
        .main-cardImage-image,
        .main-cardImage-imageWrapper {
          border-radius: 8px;
        }

        .main-trackList-rowImage {
          border-radius: 4px;
        }

        /* FullScreen Styles */
        .npv-background-image__overlay {
          backdrop-filter: saturate(1.3) brightness(0.5);
        }

        .npv-main-container,
        .npv-background-color,
        .npv-lyrics__gradient-background {
          background-color: rgba(var(--spice-rgb-main), 0.75) !important;
          background-image: none !important;
          background: none !important;
        }
      '';
    };

    colorScheme = lib.mkForce "custom";
    customColorScheme = {
      text = colors.base05;
      subtext = colors.base04;
      main = colors.base00;
      sidebar = colors.base00;
      player = colors.base00;
      card = colors.base01;
      shadow = colors.base00;
      selected-row = colors.base02;
      button = colors.base0D;
      button-active = colors.base0C;
      button-disabled = colors.base03;
      tab-active = colors.base0D;
      notification = colors.base0B;
      notification-error = colors.base08;
      misc = colors.base03;
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
