{ config, pkgs, inputs, ... }: {
    imports = [
        inputs.zen-browser.homeModules.beta
        ./modules/vicinae.nix
        ./modules/git.nix
        ./modules/vscode.nix
        ./modules/theming.nix
    ];

    home.username = "shure";
    home.homeDirectory = "/home/shure";
    home.stateVersion = "25.11";

    home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
    };

    home.packages = with pkgs; [
        bibata-cursors
    ];

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

    programs.zen-browser.enable = true;
}
