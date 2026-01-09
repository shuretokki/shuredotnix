# https://wiki.nixos.org/wiki/GVFS
# https://search.nixos.org/options?query=services.gvfs
# https://search.nixos.org/options?query=xdg.portal

{ config, lib, pkgs, ... }:
let
  cfg = config.library.core.files;
in
{
  options.library.core.files = {
    enable = lib.mkEnableOption "File manager integrations";
  };

  config = lib.mkIf cfg.enable {
    # preview files by pressing Spacebar in the file manager
    services.gnome.sushi.enable = true;

    # generate thumbnails for images, videos, etc.
    services.tumbler.enable = true;

    programs.nautilus-open-any-terminal = {
      enable = true;
      # Terminal choice is set via dconf in Home Manager (bundlers/desktop/files.nix)
    };

    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/desktops/gvfs.nix
    # Allows mounting phones (MTP), cameras (PTP), network shares (SMB/FTP) in file manager.
    services.gvfs.enable = true;

    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/hardware/udisks2.nix
    # allows non-root users to mount removable drives (USB, etc.) via polkit.
    services.udisks2.enable = true;

    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/xdg/portal.nix
    # portals provide secure access to system resources (file picker, screenshare, etc.)
    # for sandboxed apps (Flatpak) and standard apps outside the DE.
    xdg.portal = {
      enable = true;

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
    };
  };
}
