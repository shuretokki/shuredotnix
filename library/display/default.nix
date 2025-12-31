{ config, pkgs, inputs, vars, ... }:
let
  hyprland-config = import ./hyprland { inherit config pkgs vars; };
in {
  imports = [ ./stylix.nix ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [
    swaynotificationcenter
    hyprshot
    swww
    hyprsunset
    playerctl
    vicinae
    libnotify
    wl-clipboard

    # vicinae exts deps
    imagemagick
    matugen
    pulseaudio # pactl

    kdePackages.qtwayland
  ] ++ hyprland-config.scripts;

  services.power-profiles-daemon.enable = true;

  home-manager.users.${vars.username} = {
    imports = [
      ./waybar
      ./swayosd
      ./hyprlock
      ./hypridle
      ./swaync
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      ];
      settings = hyprland-config.settings;
    };
  };
}
