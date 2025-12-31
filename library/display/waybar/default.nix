{ config, pkgs, vars, ... }:
let
  colors = config.lib.stylix.colors;
  themeDir = ../themes + "/${vars.theme}";
  themeWaybar = if builtins.pathExists (themeDir + "/waybar.nix")
                then import (themeDir + "/waybar.nix") { inherit colors; }
                else {};

  borderRadius = themeWaybar.borderRadius or "0px";
  barHeight = themeWaybar.barHeight or 26;
  moduleSpacing = themeWaybar.moduleSpacing or 0;
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        "reload_style_on_change" = true;
        "layer" = "top";
        "position" = "top";
        "spacing" = moduleSpacing;
        "height" = barHeight;
        "margin-top" = 4;
        "margin-left" = 0;
        "margin-right" = 0;
        "modules-left" = [ "hyprland/workspaces" ];
        "modules-center" = [ "mpris" ];
        "modules-right" = [ "network" "pulseaudio" "battery" "clock" ];

        "hyprland/workspaces" = {
          "on-click" = "activate";
          "active-only" = false;
          "all-outputs" = true;
          "format" = "{name}";
          "persistent-workspaces" = {
            "*" = 5;
          };
        };

        "cpu" = {
          "interval" = 5;
          "format" = "󰍛";
          "on-click" = "${vars.terminal} -e btop";
        };

        "memory" = {
          "interval" = 5;
          "format" = "󰘚";
          "on-click" = "${vars.terminal} -e btop";
        };

        "network" = {
          "format-wifi" = "";
          "format-ethernet" = "󰈀";
          "format-disconnected" = "󰖪";
          "tooltip-format" = "{essid} ({signalStrength}%)";
          "on-click" = "nm-connection-editor";
        };

        "pulseaudio" = {
          "format" = "{icon}";
          "format-muted" = "󰝟";
          "format-icons" = {
            "default" = [ "󰕿" "󰖀" "󰕾" ];
          };
          "on-click" = "pavucontrol";
          "tooltip-format" = "{volume}%";
        };

        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{icon}";
          "format-charging" = "󰂄";
          "format-plugged" = "󰂄";
          "format-icons" = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰁿" "󰂁" "󰂂" "󰁹" ];
          "tooltip-format" = "{capacity}%";
        };

        "clock" = {
          "format" = "{:%H:%M}";
          "tooltip-format" = "{:%A, %B %d, %Y}";
        };

        "mpris" = {
          "format" = "{player_icon} {title} - {artist}";
          "format-paused" = "{status_icon} <i>{title} - {artist}</i>";
          "player-icons" = {
            "default" = "󰐊";
            "spotify" = "";
          };
          "status-icons" = {
            "paused" = "󰏤";
          };
          "max-length" = 40;
        };
      };
    };
    style = ''
      * {
          font-family: "${config.stylix.fonts.monospace.name}";
          font-size: 12px;
          min-height: 0;
      }

      window#waybar {
          background-color: transparent;
          color: #${colors.base05};
      }

      #workspaces {
          background-color: #${colors.base00};
          margin-top: 5px;
          margin-bottom: 5px;
          margin-left: 5px;
          border-radius: ${borderRadius};
      }

      #workspaces button {
          padding: 0px 8px;
          color: #${colors.base05};
          border-radius: ${borderRadius};
      }

      #workspaces button.active {
          background-color: #${colors.base0D};
          color: #${colors.base00};
      }

      #workspaces button.urgent {
          background-color: #${colors.base08};
          color: #${colors.base00};
      }

      #network,
      #pulseaudio,
      #custom-battery,
      #battery,
      #clock,
      #mpris {
          background-color: #${colors.base00};
          border-radius: ${borderRadius};
          padding: 0px 4px;
          margin-top: 5px;
          margin-bottom: 5px;
          margin-right: 5px;
      }

      #mpris {
          padding: 0px 32px;
      }

      #clock {
          font-weight: 700;
      }

      #battery.charging,
      #battery.plugged {
          color: #${colors.base0B};
          border-color: #${colors.base0B};
      }

      #network.disconnected {
          color: #${colors.base08};
          border-color: #${colors.base08};
      }

      #custom-expand-icon {
          margin-right: 20px;
      }

      tooltip {
          padding: 2px;
          background-color: #${colors.base00};
          border: 1px solid #${colors.base0D};
      }

      tooltip label {
          color: #${colors.base05};
      }

      #custom-update {
          font-size: 10px;
      }

      .hidden {
          opacity: 0;
      }

      #custom-screenrecording-indicator {
          min-width: 12px;
          margin-left: 8.75px;
          font-size: 10px;
      }

      #custom-screenrecording-indicator.active {
          color: #${colors.base08};
      }

      /* abillity to override */
      ${themeWaybar.css or ""}
    '';
  };
}
