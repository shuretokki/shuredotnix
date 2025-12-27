{ config, pkgs, inputs, vars, ... }:
let
  hyprland-config = import ./hyprland { inherit pkgs; };
in {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [
    swaynotificationcenter
    hyprshot
    hyprpaper
    hyprsunset
    playerctl
    vicinae
    libnotify
    wl-clipboard
  ] ++ hyprland-config.scripts;

  home-manager.users.${vars.username} = {
    imports = [
      ./wp
      ./waybar
      ./swayosd
      ./hyprlock
      ./hypridle
      ./swaync
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      ];
      settings = hyprland-config.settings;
    };
  };
}
