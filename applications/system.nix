{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
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
