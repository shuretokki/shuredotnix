# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/loader/efi.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/loader/grub/grub.nix

{ lib, config, ... }:
{
  boot.loader.efi = {
    # Allow installer to modify EFI boot variables (required for UEFI systems)
    canTouchEfiVariables = true;
  };

  # disabled in favor of GRUB
  boot.loader.systemd-boot = {
    enable = false;

    # Disable boot menu editor (pressing 'e') for security
    # Editor allows bypassing root via init=/bin/sh
    # editor = false;

    # Maximum generations to keep in boot menu
    # configurationLimit = 10;

    # Console resolution: "0" (80x25), "1" (80x50), "auto", "max", "keep"
    # consoleMode = "auto";
  };

  boot.loader.grub = {
    enable = true;

    # "nodev" = EFI-only, skip MBR install
    # "/dev/sda" = install to MBR for BIOS systems
    device = "nodev";
    
    efiSupport = true;

    # Detect other operating systems (Windows, other Linux distros)
    useOSProber = true;

    theme = lib.mkIf config.theme.grub.enable config.theme.grub.theme;

    # Maximum generations in boot menu
    # configurationLimit = 10;

    # Serial console for headless servers
    # extraConfig = ''
    #   serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
    #   terminal_input --append serial
    #   terminal_output --append serial
    # '';

    # Custom menu entries
    # extraEntries = ''
    #   menuentry "Reboot" { reboot }
    #   menuentry "Poweroff" { halt }
    # '';
  };
}