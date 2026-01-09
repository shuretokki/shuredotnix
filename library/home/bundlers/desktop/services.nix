# https://home-manager-options.extranix.com/?query=services.network-manager-applet
# https://home-manager-options.extranix.com/?query=services.blueman-applet
# https://home-manager-options.extranix.com/?query=services.udiskie
# https://home-manager-options.extranix.com/?query=services.playerctld
# https://home-manager-options.extranix.com/?query=services.kdeconnect
{ lib, pkgs, ... }: {
  services.network-manager-applet.enable = lib.mkDefault true;
  services.blueman-applet.enable = lib.mkDefault true;
  services.udiskie.enable = lib.mkDefault true;
  services.playerctld.enable = lib.mkDefault true;

  # phone integration (notifications, clipboard, file transfer)
  services.kdeconnect = {
    enable = lib.mkDefault true;
    indicator = true;
  };
}
