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
          .notification-content,
          .notification,
          .notification-row,
          .control-center {
            border: none !important;
            box-shadow: none !important;
          }
        '';
    };
}