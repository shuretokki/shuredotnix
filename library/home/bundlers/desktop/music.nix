# Music Applications
# https://github.com/Gerg-L/spicetify-nix
{ lib, pkgs, config, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  colors = config.lib.stylix.colors.withHashtag;
in {
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

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

    additonalCss = ''
      .main-nowPlayingWidget-coverArt {
        border-radius: 8px;
      }
    '';

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
    youtube-music
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
