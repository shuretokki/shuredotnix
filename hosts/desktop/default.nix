{ config, pkgs, vars, ... }: {
    imports = [
        ./hardware-configuration.nix

        ../../library/core
        ../../library/display/sddm-config.nix
        ../../library/display/default.nix
        ../../packages
    ];

    environment.systemPackages = with pkgs; [
        apple-cursor
    ];

    system.stateVersion = "25.11";
}
