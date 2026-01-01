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

          /* Remove Topbar background colour */
          .main-topBar-background {
            background-color: black !important;
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
            fill: black;
          }


          /** Hightlight selected playlist */
          .main-rootlist-rootlistItemLink.main-rootlist-rootlistItemLinkActive {
            background: var(--spice-button) !important;
            border-radius: 4px;
            padding: 0 10px;
            margin: 0 5px 0 -10px;
          }

          .main-navBar-navBarLinkActive {
            background: var(--spice-button);
          }

          .main-contextMenu-menu {
            background-color: var(--spice-button);
          }

          .main-contextMenu-menuHeading,
          .main-contextMenu-menuItemButton,
          .main-contextMenu-menuItemButton:not(.main-contextMenu-disabled):focus,
          .main-contextMenu-menuItemButton:not(.main-contextMenu-disabled):hover {
            color: var(--spice-text);
          }

          .main-playPauseButton-button {
            background-color: var(--spice-button);
            color: black;
          }

          /** Queue page header */
          .queue-queue-title,
          .queue-playHistory-title {
            color: var(--spice-text) !important;
          }

          /** Cards */
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

          /* left menu active item background */
          .main-navBar-navBarLinkActive {
            color: white;
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

          /* Context Menu */
          .main-contextMenu-menu {
            background-color: var(--spice-misc) !important;
          }

          /* Experimental features background */
          .main-trackCreditsModal-container {
            background-color: var(--spice-misc) !important;
          }

          /* device showing menu */
          .main-connectBar-connectBar.mVVxN9ZfIRjiQfDuzPCZ {
            background-color: var(--spice-button) !important;
            color: var(--text-base);
          }


        /* New lyrics style */

        :root {
          --lyrics-text-direction: left;
        }

        .main-lyricsCinema-controls {
          top: 80px !important;
        }

        #lyrics-backdrop {
          position: absolute;
          width: 100%;
          height: 100%;
          background-color: black !important;
        }

        #lyrics-backdrop-container {
          position: absolute;
          width: 100%;
          height: 100%;
          background-color: black !important;
        }

        .lyrics-lyrics-background {
          visibility: hidden !important;
        }


        /* lyrics not available message */
        .C3pBU1DsOUJJOAv89ZFT {
          color: var(--lyrics-color-passed) !important;
          opacity: 0;
          animation: reveal 800ms ease forwards;
        }

        @keyframes reveal {
          from {
            opacity: 0;
          }

          to {
            opacity: 1;
            visibility: visible;
          }
        }

        .lyrics-lyricsContent-lyric:hover {
          color: var(--lyrics-color-active) !important;
        }

        .lyrics-lyricsContent-active {
          text-shadow: 0 0 15px rgba(255, 255, 255, 0.6);
          max-width: var(--lyrics-active-max-width);
        }

        @media (min-width: 1920px) {
          .lyrics-lyricsContent-lyric {
            transition: text-shadow 400ms ease, color 50ms ease;
          }

          .lyrics-lyricsContent-text {
            transform: scale(1);
            transition: transform 400ms ease;
          }

          .lyrics-lyricsContent-active .lyrics-lyricsContent-text {
            transform: scale(1.1);
          }

          .lyrics-lyricsContent-isInteractive .lyrics-lyricsContent-text:active {
            transform: scale(0.9);
          }
        }

        .main-nowPlayingView-section .lyrics-lyricsContent-lyric {
          opacity: 1;
          visibility: visible;
        }

        .main-nowPlayingView-section .lyrics-lyricsContent-text {
          transform: unset;
        }

        /* New Lyrics Plus style */

        .lyrics-lyricsContainer-LyricsBackground {
          display: none !important;
        }

        /* lyrics pages fix */

        .main-lyricsCinema-nonDisplayedArea .main-topBar-topbarContent {
          display: none;
        }

        .lyrics-lyrics-container {
          margin-top: 0;
        }

        .lyrics-lyricsContainer-LyricsBackground {
          margin-bottom: -110px;
          margin-top: -10px;
        }

        .lyrics-lyricsContainer-Provider {
          padding-bottom: 40px;
        }

        #lyrics-fullscreen-container
          > .lyrics-lyricsContainer-LyricsContainer:has(
            .lyrics-lyricsContainer-UnsyncedLyricsPage
          )
          .lyrics-lyricsContainer-Provider {
          padding-bottom: 35px;
        }

        .lyrics-lyricsContainer-LyricsUnsyncedPadding {
          height: 20vh;
        }

        .lyrics-config-button-container {
          bottom: 15px;
        }

        #lyrics-fullscreen-container .lyrics-config-button-container {
          bottom: 10px;
        }

        #fad-lyrics-plus-container .lyrics-config-button-container {
          bottom: 32px;
        }

        body:has(#lyrics-fullscreen-container)
          > #main
          > .Root
          > .Root__top-container
          > *:not(.Root__main-view),
        body:has(#lyrics-fullscreen-container)
          > #main
          > .Root
          > .Root__top-container
          > .Root__main-view
          > *:not(.main-view-container),
        body:has(#lyrics-fullscreen-container)
          > #main
          > .Root
          > .Root__top-container
          > .Root__main-view
          > .main-view-container
          > *:not(.under-main-view),
        body:has(#lyrics-fullscreen-container)
          > #main
          > .Root
          > .Root__top-container
          > .Root__main-view::before {
          display: none !important;
        }

        body:has(#lyrics-fullscreen-container) > #main > .Root {
          --panel-gap: 0 !important;
        }

        .hKccLC {
          background-color: var(--spice-accent);
          color: var(--spice-alt-text);
          border-radius: var(--border-radius-3);
        }

        .ksogXh:hover {
          color: var(--spice-rgb-subtext);
        }

        .main-view-container__scroll-node-child,
        .main-yourLibraryX-libraryItemContainer,
        .main-buddyFeed-content,
        .nw2W4ZMdICuBo08Tzxg9
        {
          padding-bottom: 6rem;
        }

        .view-homeShortcutsGrid-imageContainer {
          padding: 6px;
        }

        .view-homeShortcutsGrid-shortcut .view-homeShortcutsGrid-image {
          border-radius: var(--border-radius-3);
        }

        .main-trackList-playsHeader {
          width: 12.8ch;
        }

        .main-trackList-durationHeader {
          margin-left: 30px;
        }

        .main-trackList-rowSectionEnd {
          margin: auto;
        }

        .main-trackList-column {
          padding-left: 10px;
        }

        .main-trackList-rowSectionVariable[aria-colindex="3"] .cPwEdQ,
        .main-trackList-rowSectionVariable[aria-colindex="3"] .main-trackList-text {
          padding-left: 8.5px;
        }

        .main-trackList-rowSectionVariable[aria-colindex="4"] .eDbSCl {
          padding-left: 14.5px;
        }

        .main-trackList-rowSectionVariable[aria-colindex="3"]
          .main-trackList-rowPlayCount {
          padding-left: 0px;
        }

        .SxHlW6byhoJSUJNugaE1 .k6Nq7pavAmiyJlxj52QA {
          color: var(--spice-alt-text);
        }

        .npv-background-image__overlay {
          background-color: rgba(var(--spice-rgb-layer-shadow), 0.7) !important;
        }

        .main-rootlist-rootlistItemOverlay {
          display: none;
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

        .npv-track-metadata,
        .npv-up-next {
          min-width: 6rem;
          border: 2px solid
            rgba(var(--spice-rgb-main), var(--bg-color-opacity-homeHeader));
          padding: 0.5rem;
          border-radius: var(--card-border-radius);
          background-color: rgba(var(--spice-rgb-card), 0.75);
          color: rgba(var(--spice-rgb-subtext), 0.6);
        }

        .npv-up-next__info {
          color: var(--spice-text);
        }

        .pO2rsGFqUdaNhpLrif21 a {
          color: var(--spice-text) !important;
        }

        .ellipsis-one-line {
          color: var(--spice-subtext) !important;
        }

        .npv-lyrics__text--credits,
        .npv-track-metadata__creator-name,
        .npv-lyrics__text-wrapper--previous,
        .npv-lyrics__text--credits {
          color: rgba(var(--spice-rgb-text), 0.5) !important;
        }

        ::backdrop {
          backdrop-filter: blur(3rem) saturate(1.3) invert(0.0125) brightness(0.5);
          background-color: rgba(var(--spice-rgb-main), 0.75);
        }

        .yhlH4Dsjqw56Z58EOwvQ {
          background: -webkit-gradient(linear, left top, left bottom, from(transparent), to(rgba(var(--spice-rgb-shadow), .6))), var(--background-noise);
        }


        .encore-dark-theme .encore-bright-accent-set{
          --background-highlight: #b7b6b6;
          --background-press: #797979;
        }


        /* scrollbar hide */

        .os-scrollbar.os-scrollbar-handle-interactive .os-scrollbar-handle, .os-scrollbar.os-scrollbar-track-interactive .os-scrollbar-track{
          width: 0 !important;
        }

        /* black gradient */
        .XVz4BMGP5zAEE5p90mYK{
          --background-base: black !important;
          --background-base-min-contrast: black !important;

        }

        .Bdcf5g__Rug3TGqSdbiy{
            --background-base-70: black !important;
        }

        /* white text instead of accented color */
        .encore-internal-color-text-subdued {
          color: white;
        }

        /* fullscreen artist page*/
        .wozXSN04ZBOkhrsuY5i2, .XUwMufC5NCgIyRMyGXLD{
          height: 90vh;
          clip-path: inset(0 0 17vh 0);
        }

        .main-entityHeader-container.main-entityHeader-withBackgroundImage {
          height: 73vh;
        }

        .dhq75ObRGjfBoBlz6clW:after{
          height: 90vh;
          background-color: transparent;
        }
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
