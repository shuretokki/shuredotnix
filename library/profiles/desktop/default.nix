# desktop profile: enables all components for a gui workstation.
# used by hosts that need full desktop environment.
#
# this profile bundles:
# - core services (audio, bluetooth, fonts, input, files)
# - display (sddm, hyprland)
# - home-manager bundlers (cli + desktop apps)
#
# to customize which features are enabled, override in host config:
# library.core.bluetooth.enable = false;

{ config, lib, pkgs, identity, ... }: {
  imports = [
    ../../display
  ];

  # all enabled by default for desktop use.
  # mkDefault allows hosts to override if needed.
  library.core.audio.enable = lib.mkDefault true;
  library.core.bluetooth.enable = lib.mkDefault true;
  library.core.fonts.enable = lib.mkDefault true;
  library.core.input.enable = lib.mkDefault true;
  library.core.files.enable = lib.mkDefault true;

  library.display.sddm.enable = lib.mkDefault true;
  library.display.hyprland.enable = lib.mkDefault true;

  # system-wide packages available in $PATH.
  # prefer home-manager for user apps; these are for system-level tools.
  environment.systemPackages = with pkgs; [
    wget2 curl git unzip zip sd
    nil nixfmt-rfc-style direnv

    blueman wireplumber pamixer
    pavucontrol networkmanagerapplet
    qt6Packages.fcitx5-configtool
    typora
  ];

  # https://search.nixos.org/options?query=programs.localsend
  programs.localsend = {
    enable = true;

    # opens port 53317 (tcp/udp) in firewall.
    # required for device discovery and file transfer.
    openFirewall = true;
  };

  # bundlers configure apps based on _prefs from users/<name>/home.nix.
  home-manager.users.${identity.username} = {
    imports = [
      ../../home/bundlers/cli
      ../../home/bundlers/desktop
    ];
  };
}
