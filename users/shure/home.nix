{ config, pkgs, inputs, vars, ... }: {
    imports = [
        ../../library/home/vicinae.nix
        ../../library/home/git.nix
        ../../library/home/vscode.nix
        ../../library/home/theming.nix
        ../../library/home/services.nix
        ../../library/home/music.nix
        ../../library/home/browser.nix
        ../../library/home/terminal.nix
        ../../library/home/shell.nix
        ../../library/home/apps.nix
        ../../library/home/variables.nix
        ../../library/home/mime.nix
    ];

    home.username = vars.username;
    home.homeDirectory = "/home/${vars.username}";
    home.stateVersion = "25.11";
}
