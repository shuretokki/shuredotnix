# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/nix-flakes.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/nix-channel.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/tasks/network-interfaces.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/dconf.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/desktops/gvfs.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/hardware/udisks2.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/nh.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/xdg/portal.nix

{ config, pkgs, vars, inputs, ... }: {
  nix = {
    # Pin the registry to the flake input to prevent downloading the registry
    # every time commands like `nix shell` are run.
    registry.nixpkgs.flake = inputs.nixpkgs;

    # Ensures legacy commands (nix-channel) still work consistent with the flake
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    settings = {
      # Automatically deduplicate the Nix store
      # Saves disk space by hardlinking identical files
      auto-optimise-store = true;

      experimental-features = [ "nix-command" "flakes" ];

      # Trusted users who can configure binary caches
      # trusted-users = [ "root" "@wheel" ];

      # Users allowed to interact with the Nix daemon
      # allowed-users = [ "@wheel" ];

      # Parallelism settings, tho defaults are usually fine
      # max-jobs = "auto";
      # cores = 0;
    };
  };

  networking.hostName = vars.hostname;

  # (optional)
  # networking.networkmanager.enable = true;
  # networking.firewall.enable = true;

  # Configuration storage system for GNOME/GTK apps
  # Required for saving theme settings, terminal preferences, etc.
  programs.dconf.enable = true;

  # Allows mounting phones (MTP), cameras (PTP), network shares (SMB/FTP) in file manager.
  services.gvfs = {
    enable = vars.features.desktop;
    # package = pkgs.gvfs;
  };

  # Allows non-root users to mount removable drives (USB, etc.) via polkit.
  services.udisks2 = {
    enable = vars.features.desktop;
    # mountOnMedia = false; # Mount to /media instead of /run/media/$USER
  };

  programs.nh = {
    enable = true;

    # an Automatic Garbage Collection
    clean = {
      enable = true;
      # Removing old generations:
      # --keep-since 4d: Keep generations from the last 4 days
      # --keep 3: Keep at least the last 3 generations (failsafe)
      extraArgs = "--keep-since 4d --keep 3";

      # Frequency (systemd time format)
      # dates = "weekly";
    };

    # The path to your flake configuration
    # Required for `nh os switch` to work without specifying path
    flake = "/home/${vars.username}/shuredotnix";
  };

  # Portals provide secure access to system resources (file picker, screenshare, etc.)
  # for sandboxed apps (Flatpak) and standard apps outside the DE.
  xdg.portal = {
    enable = vars.features.desktop;

    # Using the GTK portal (works well for GNOME/Wayland/Hyprland)
    # Provides the actual dialog windows for file picking, etc.
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    # Common portals:
    # - pkgs.xdg-desktop-portal-gtk (GNOME/GTK-based)
    # - pkgs.xdg-desktop-portal-kde (Plasma)
    # - pkgs.xdg-desktop-portal-hyprland (Hyprland specifics: screencast, global shortcuts)
    # - pkgs.xdg-desktop-portal-wlr (Generic Wayland)

    # use the first available portal for all interfaces
    config.common.default = "*";

    # Force use of portal for xdg-open
    # xdgOpenUsePortal = false;
  };
}
