{ config, pkgs, vars, ... }: {
    imports = [
        ./hardware-configuration.nix

        ../../library/core
        ../../library/display/default.nix
        ../../packages
    ];

    library.display.sddm.enable = true;
    library.display.hyprland.enable = true;

    system.stateVersion = "25.11";
}
