{ lib, pkgs, config, ... }: {
    boot.loader.systemd-boot.enable = false;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        theme = lib.mkIf config.theme.grub.enable config.theme.grub.theme;
    };
}