# https://wiki.nixos.org/wiki/Bootloader
# https://search.nixos.org/options?query=boot.loader

{ lib, config, identity, ... }:
{
  boot.loader.efi = {
    # allow installer to modify EFI boot variables (required for UEFI systems)
    canTouchEfiVariables = true;
  };

  # disabled in favor of limine
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


  # https://search.nixos.org/options?query=boot.loader.limine
  boot.loader.limine = {
    enable = true;

    # This requires you to already have generated the keys and enrolled them with sbctl.
    # To create keys use 'sbctl create-keys'.
    # To enroll them first reset secure boot to “Setup Mode”.
    # This is device specific. Then enroll them using 'sbctl enroll-keys -m -f'.
    secureBoot.enable = false;

    # limine configuration (limine.conf)
    # https://github.com/limine-bootloader/limine/blob/v8.x/CONFIG.md
    extraEntries = ''
      /Windows
        protocol: efi_chainload
        path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };
}
