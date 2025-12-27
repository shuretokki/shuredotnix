{ config, pkgs, inputs, ... }: {
    imports = [
        inputs.zen-browser.homeModules.beta
        # or inputs.zen-browser.homeModules.twilight
        # or inputs.zen-browser.homeModules.twilight-official
        ./modules/vicinae.nix
        ./modules/git.nix
        ./modules/vscode.nix
        ./modules/theming.nix
    ];

    home.username = "shure";
    home.homeDirectory = "/home/shure";
    home.stateVersion = "25.11";

    programs.bash = {
        enable = true;
        shellAliases = {
            rebuild = "sudo nixos-rebuild switch --flake ~/shure-nh";
            eza = "eza --icons";
        };
        profileExtra = ''
            if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
                exec uwsm start hyprland-uwsm.desktop
            fi
        '';
    };

    programs.starship = {
        enable = true;
        enableBashIntegration = true;
    };

    programs.zen-browser.enable = true;
}
