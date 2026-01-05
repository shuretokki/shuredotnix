{ config, pkgs, lib, inputs, vars, ... }:
let
  cfg = config.library.display.hyprland;
  hyprland-config = import ./hyprland { inherit config pkgs lib vars; };
in {
  options.library.display.hyprland = {
    enable = lib.mkEnableOption "Hyprland Compositor";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    # programs.uwsm.waylandCompositors.hyprland = {
    #   binPath = lib.mkForce "${pkgs.hyprland}/bin/start-hyprland";
    #   prettyName = "Hyprland";
    #   comment = "Hyprland managed by UWSM";
    # };

    environment.systemPackages = with pkgs; [
      swaynotificationcenter
      hyprshot
      swww
      hyprsunset
      playerctl
      vicinae
      libnotify

      apple-cursor

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
  };
}
