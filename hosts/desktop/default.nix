{ config, pkgs, vars, ... }: {
    imports = [
        ./hardware-configuration.nix

        ../../library/core
        ../../library/display/default.nix
        ../../packages
    ];

    library.core.audio.enable = true;
    library.core.bluetooth.enable = true;
    library.core.fonts.enable = true;
    library.core.input.enable = true;
    library.core.files.enable = true;
  library.core.virtualisation.docker.enable = true;

    library.display.sddm.enable = true;
    library.display.hyprland.enable = true;

    system.stateVersion = "25.11";
}
