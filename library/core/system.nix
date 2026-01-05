# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/nix-flakes.nix

{ config, pkgs, lib, vars, inputs, ... }:
let
  cfg = config.library.core.system;
in {
  options.library.core.system = {
    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "/home/${vars.username}/shuredotnix";
      description = "Path to the NixOS flake for nh";
    };
  };

  config = {
    nix = {
      # pin the registry to the flake input to prevent downloading the registry
      # every time commands like `nix shell` are run.
      registry.nixpkgs.flake = inputs.nixpkgs;

      # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/nix-channel.nix
      # ensures legacy commands (nix-channel) still work consistent with the flake
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

      settings = {
        # automatically deduplicate the Nix store
        # saves disk space by hardlinking identical files
        auto-optimise-store = true;

        experimental-features = [ "nix-command" "flakes" ];

        # trusted users who can configure binary caches
        # trusted-users = [ "root" "@wheel" ];

        # users allowed to interact with the Nix daemon
        # allowed-users = [ "@wheel" ];

        # parallelism settings, tho defaults are usually fine
        # max-jobs = "auto";
        # cores = 0;
      };
    };


    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/tasks/network-interfaces.nix
    networking.hostName = lib.mkDefault vars.hostname;

    # (optional)
    # networking.networkmanager.enable = true;
    # networking.firewall.enable = true;


    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/dconf.nix
    # configuration storage system for GNOME/GTK apps
    # required for saving theme settings, terminal preferences, etc.
    programs.dconf.enable = true;


    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/desktops/gvfs.nix
    # Allows mounting phones (MTP), cameras (PTP), network shares (SMB/FTP) in file manager.
    services.gvfs = {
      enable = config.library.display.hyprland.enable;
      # package = pkgs.gvfs;
    };


    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/hardware/udisks2.nix
    # allows non-root users to mount removable drives (USB, etc.) via polkit.
    services.udisks2 = {
      enable = config.library.display.hyprland.enable;
      # mountOnMedia = false; # mount to /media instead of /run/media/$USER
    };

    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/nh.nix
    programs.nh = {
      enable = true;

      # an automatic garbage collection
      clean = {
        enable = true;
        # removing old generations:
        # --keep-since 4d: keep generations from the last 4 days
        # --keep 3: keep at least the last 3 generations (failsafe)
        extraArgs = "--keep-since 4d --keep 3";

        # frequency (systemd time format)
        # dates = "weekly";
      };

      # the path to your flake configuration
      # required for `nh os switch` to work without specifying path
      flake = cfg.flakePath;
    };

    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/xdg/portal.nix
    # portals provide secure access to system resources (file picker, screenshare, etc.)
    # for sandboxed apps (Flatpak) and standard apps outside the DE.
    xdg.portal = {
      enable = config.library.display.hyprland.enable;

      # using the GTK portal (works well for GNOME/Wayland/Hyprland)
      # provides the actual dialog windows for file picking, etc.
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

      # common portals:
      # - pkgs.xdg-desktop-portal-gtk (GNOME/GTK-based)
      # - pkgs.xdg-desktop-portal-kde (Plasma)
      # - pkgs.xdg-desktop-portal-hyprland (Hyprland specifics: screencast, global shortcuts)
      # - pkgs.xdg-desktop-portal-wlr (Generic Wayland)

      # use the first available portal for all interfaces
      config.common.default = "*";

      # force use of portal for xdg-open
      # xdgOpenUsePortal = false;
    };
  };
}
