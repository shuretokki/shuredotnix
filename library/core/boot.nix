# https://wiki.nixos.org/wiki/Bootloader
# https://search.nixos.org/options?query=boot.loader

{ lib, config, pkgs, ... }:
let
  cfg = config.boot.dualBoot;
in
{
  options.boot.dualBoot = {
    windows = {
      enable = lib.mkEnableOption "Windows Dual Boot";
      uuid = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "uuid of the windows efi partition. set this if windows is on a different drive.";
      };
      label = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "filesystem label of the windows efi partition.";
      };
    };

    macos = {
      enable = lib.mkEnableOption "MacOS (OpenCore) Dual Boot";
      uuid = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "uuid of the macos efi partition. set this if opencore is on a different drive.";
      };
      label = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "filesystem label of the macos efi partition.";
      };
    };

    extraEntries = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "extra limine configuration entries.";
    };
  };

  config = {
    boot.loader.efi = {
      # allow installer to modify efi boot variables (required for uefi systems)
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

      # limine on nixos does not have 'osProber' (unlike grub).
      # we manually generate entries based on dualBoot config.
      #
      # windows warning: bitlocker will detect the boot change on first run and ask for recovery key.
      # macos warning: ensure launcheroption is disabled in opencore config.plist to prevent boot loops.
      extraEntries = let
        makePrefix = uuid: label:
          if uuid != null then "uuid(${lib.toUpper uuid}):"
          else if label != null then "label(${label}):"
          else "boot():";

        winPrefix = makePrefix cfg.windows.uuid cfg.windows.label;
        macPrefix = makePrefix cfg.macos.uuid cfg.macos.label;
      in ''
        ${lib.optionalString cfg.windows.enable ''
          /Windows
            protocol: efi_chainload
            path: ${winPrefix}/EFI/Microsoft/Boot/bootmgfw.efi
        ''}
        ${lib.optionalString cfg.macos.enable ''
          /MacOS
            protocol: efi_chainload
            path: ${macPrefix}/EFI/OC/OpenCore.efi
        ''}
        ${cfg.extraEntries}
      '';
    };

    environment.systemPackages = [ pkgs.detect-boot-uuids ];
  };
}
