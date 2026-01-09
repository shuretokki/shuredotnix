# https://wiki.hyprland.org/
# https://search.nixos.org/options?query=programs.hyprland

{ config, pkgs, lib, inputs, identity, ... }:
let
  cfg = config.library.display.hyprland;
  hyprland-base = import ./hyprland/base.nix { inherit config pkgs lib; };
in
{
  options.library.display.hyprland = {
    enable = lib.mkEnableOption "Hyprland Compositor";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;

      # uwsm manages hyprland as a systemd service.
      # allows proper session management and service ordering.
      withUWSM = true;

      xwayland.enable = true;

      # uses flake input for latest hyprland and matching portal
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

      apple-cursor

      # TODO: might move this elsewhere
      # vicinae extension dependencies
      imagemagick
      matugen
      pulseaudio # pactl

      kdePackages.qtwayland
    ] ++ hyprland-base.scripts;

    services.power-profiles-daemon.enable = true;

    home-manager.users.${identity.username} = { prefs, ... }: {
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

        # base.nix contains decoration, animations, window rules.
        # keybinds and mkeybinds are imported separately.
        settings = hyprland-base.settings // {
          bind = import ./hyprland/keybinds.nix { inherit pkgs prefs; };
          bindm = import ./hyprland/mkeybinds.nix { inherit pkgs; };
        };
      };
    };
  };
}
