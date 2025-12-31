{ lib, pkgs, ... }: {
  services.network-manager-applet.enable = lib.mkDefault true;
  services.blueman-applet.enable = lib.mkDefault true;
  services.udiskie.enable = lib.mkDefault true;
  services.easyeffects.enable = lib.mkDefault true;
  services.playerctld.enable = lib.mkDefault true;

  home.packages = with pkgs; [
    pavucontrol
    # easyeffects is installed by services.easyeffects
  ];
}
