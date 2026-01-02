{ config, pkgs, vars, ... }: {
    imports = [
        ./hardware-configuration.nix

        ../../library/core
        ../../library/display/sddm-config.nix
        ../../library/display/default.nix
        ../../packages
    ];

    system.stateVersion = "25.11";
}
