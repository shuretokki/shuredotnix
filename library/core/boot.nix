# https://wiki.nixos.org/wiki/Bootloader
# https://search.nixos.org/options?query=boot.loader

{ lib, config, identity, ... }:
{

  boot.loader.efi = {
    # allow installer to modify EFI boot variables (required for UEFI systems)
    canTouchEfiVariables = true;
  };

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = false;

  # https://search.nixos.org/options?query=boot.loader.limine
  boot.loader.limine = {
    enable = true;

    # this requires you to already have generated the keys and enrolled them with sbctl.
    # to create keys use 'sbctl create-keys'.
    # to enroll them first reset secure boot to “Setup Mode”. this is device specific.
    # then enroll them using 'sbctl enroll-keys -m -f'.
    secureBoot.enable = false;

    # maximum number of system generations to display in the boot menu.
    # a limit prevents the boot partition from running out of space.
    maxGenerations = lib.mkDefault 10;

    # determines if the limine configuration editor is enabled at boot.
    # disabling it prevents temporary modification of boot parameters (security).
    enableEditor = false;

    # limine on NixOS does not have 'osProber' (unlike GRUB).
    # you must manually add entries for other OSs (Dual Boot).
    # default windows path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
    # for macos might be boot():/EFI/BOOT/bootx64.efi or /System/Library/CoreServices/boot.efi
    # since i can't verify it yet, i willn't add it in
    extraEntries = ''
      /Windows
        protocol: efi_chainload
        path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };
}
