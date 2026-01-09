# https://syncthing.net/
# https://home-manager-options.extranix.com/?query=services.syncthing
{ lib, ... }: {
  services.syncthing = {
    enable = lib.mkDefault true;

    tray.enable = true;

    # extraOptions = [ "--no-browser" ];
  };
}
