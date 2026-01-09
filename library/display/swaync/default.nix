# https://github.com/ErikReider/SwayNotificationCenter
# https://home-manager-options.extranix.com/?query=services.swaync

{ config, pkgs, ... }: {
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-margin-top = 10;
      control-center-margin-bottom = 1;
      control-center-margin-right = 10;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
    };
    style = ''
      * {
        border: none !important;
        box-shadow: none !important;
      }
    '';
  };
}
