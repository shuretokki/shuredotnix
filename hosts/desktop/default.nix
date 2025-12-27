{ config, pkgs, vars, ... }: {
    imports = [
        ./hardware.nix

        ../../library/core/boot.nix
        ../../library/core/audio.nix
        ../../library/core/network.nix
        ../../library/core/bluetooth.nix
        ../../library/core/security.nix

        ../../library/display/fonts.nix
        ../../library/display/default.nix

        ../../applications

        ../../users/shure/users.nix
    ];

    nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
    };

    nix.settings = {
        auto-optimise-store = true;

        substituters = [
            "https://hyprland.cachix.org"
            "https://vicinae.cachix.org"
        ];

        trusted-substituters = ["https://hyprland.cachix.org"];

        trusted-public-keys = [
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        ];
    };

    networking.hostName = vars.hostname;
    console.keyMap = "us";

    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "SilentSDDM";
    };

    environment.systemPackages = with pkgs; [
        (import ../../library/display/sddm-theme.nix {
            inherit pkgs;
            # To use a custom background, copy it into the flake and use a relative path
            # background = ../../library/display/wp/001.jpg;
            background = null;
        })
        libsForQt5.qt5.qtgraphicaleffects
        libsForQt5.qt5.qtquickcontrols2
        libsForQt5.qt5.qtsvg
        libsForQt5.qt5.qtmultimedia
    ];

    programs.dconf.enable = true;

	services.earlyoom.enable=true;
	services.earlyoom.freeMemThreshold=5;

    nix.settings.experimental-features = ["nix-command" "flakes"];
    system.stateVersion = "25.11";
}
