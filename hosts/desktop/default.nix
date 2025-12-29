{ config, pkgs, vars, ... }: {
    imports = [
        ./hardware-configuration.nix

        ../../library/core/boot.nix
        ../../library/core/audio.nix
        ../../library/core/network.nix
        ../../library/core/bluetooth.nix
        ../../library/core/security.nix
        ../../library/core/performance.nix
        ../../library/core/system.nix

        ../../library/display/fonts.nix
        ../../library/display/sddm-config.nix
        ../../library/display/default.nix

        ../../applications
    ];

    environment.systemPackages = with pkgs; [
        apple-cursor
    ];

    system.stateVersion = "25.11";
}
