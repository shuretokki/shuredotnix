{ config, pkgs, inputs, ... }:
let
    mouse-keybinds = import ./mouse-keybinds.nix { inherit pkgs; };
    keybinds = import ./keybinds.nix { inherit pkgs; };
    appearance = import ./appearance.nix;
    rules = import ./rules.nix;
    input = import ./input.nix;
    env = import ./env.nix;
    autostart = import ./autostart.nix { inherit pkgs; };
in {
    programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };

    environment.systemPackages = with pkgs; [
        # swaync
        hyprshot
        hyprpaper
        vicinae
        libnotify
        wl-clipboard
        # polkit-kde-agent
    ];

    home-manager.users.shure = {
        imports = [ 
            ./waybar.nix 
            ./swayosd.nix
            ./hyprlock.nix
        ];
        wayland.windowManager.hyprland = {
            enable = true;

            plugins = [
                inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
            ];

            settings = appearance // rules // input // env // autostart // {
                monitor = ",preferred,auto,1";
                bind = keybinds;
                bindm = mouse-keybinds;
            };
    };
};
}