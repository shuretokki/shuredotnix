{ config, pkgs, vars, ... }: {
    imports = [
        ./hardware-configuration.nix

        ../../library/core
        ../../library/display/default.nix
        ../../packages
    ];

    shure.display.sddm.enable = true;

    system.stateVersion = "25.11";
}
