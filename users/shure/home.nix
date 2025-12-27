{ config, pkgs, inputs, vars, ... }: {
    imports = [
        inputs.zen-browser.homeModules.beta
        # or inputs.zen-browser.homeModules.twilight
        # or inputs.zen-browser.homeModules.twilight-official
        ../../library/home/vicinae.nix
        ../../library/home/git.nix
        ../../library/home/vscode.nix
        ../../library/home/theming.nix
        ../../library/home/services.nix
    ];

    home.username = vars.username;
    home.homeDirectory = "/home/${vars.username}";
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

    programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
    };

    home.sessionVariables = {
        EDITOR = "code";
        BROWSER = "zen";
        TERMINAL = "warp-terminal";
    };

    xdg.mimeApps = {
        enable = true;
        defaultApplications = {
            "text/plain" = "code.desktop";
            "text/markdown" = "code.desktop";
            "x-scheme-handler/http" = "zen.desktop";
            "x-scheme-handler/https" = "zen.desktop";
            "x-scheme-handler/about" = "zen.desktop";
            "x-scheme-handler/unknown" = "zen.desktop";
            "inode/directory" = "org.gnome.Nautilus.desktop";
        };
    };
}
