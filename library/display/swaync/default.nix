{ config, pkgs, ... }:
let
    theme = import ../themes/current.nix;
in {
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
            @define-color bg-color #${theme.colors.bg};
            @define-color fg-color #${theme.colors.fg};
            @define-color accent-color #${theme.colors.blue};

            .notification {
                background: @bg-color;
                color: @fg-color;
                border: 2px solid @accent-color;
                border-radius: 0px;
            }
        '';
    };
}