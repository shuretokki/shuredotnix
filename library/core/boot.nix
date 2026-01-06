# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/loader/efi.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/loader/grub/grub.nix

{ lib, config, vars, ... }:
{
  boot.loader.efi = {
    # allow installer to modify EFI boot variables (required for UEFI systems)
    canTouchEfiVariables = true;
  };

  # disabled in favor of GRUB
  boot.loader.systemd-boot = {
    enable = false;

    # disable boot menu editor (pressing 'e') for security
    # editor allows bypassing root via init=/bin/sh
    # editor = false;

    # maximum generations to keep in boot menu
    # configurationLimit = 10;

    # console resolution: "0" (80x25), "1" (80x50), "auto", "max", "keep"
    # consoleMode = "auto";
  };

  boot.loader.grub = {
    enable = true;

    # "nodev" = EFI-only, skip MBR install
    # "/dev/sda" = install to MBR for BIOS systems
    device = "nodev";

    efiSupport = true;

    # detect other operating systems (Windows, other Linux distros)
    useOSProber = config.library.display.hyprland.enable;

    theme = lib.mkIf config.theme.grub.enable config.theme.grub.theme;

    # maximum generations in boot menu
    # configurationLimit = 10;

    # serial console for headless servers
    # extraConfig = ''
    #   serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
    #   terminal_input --append serial
    #   terminal_output --append serial
    # '';

    # custom menu entries
    # extraEntries = ''
    #   menuentry "Reboot" { reboot }
    #   menuentry "Poweroff" { halt }
    # '';
  };
}
