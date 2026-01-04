{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    ghostty
    docker
    blueman
    wireplumber
    pamixer
    pavucontrol
    networkmanagerapplet
    qt6Packages.fcitx5-configtool
  ];
}
