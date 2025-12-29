{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        kitty
        alacritty
        ghostty
        docker
        blueman
        wireplumber
        pamixer
        pavucontrol
        easyeffects
        networkmanagerapplet
        qt6Packages.fcitx5-configtool
    ];
}
