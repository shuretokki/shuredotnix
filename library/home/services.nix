{ pkgs, ... }: {
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  home.packages = with pkgs; [
    pavucontrol
  ];
}
