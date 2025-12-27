{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        "reload_style_on_change" = true;
        "layer" = "top";
        "position" = "top";
        "spacing" = 0;
        "height" = 26;
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

        "custom/omarchy" = {
          "format" = "<span font='omarchy'>\ue900</span>";
          "on-click" = "omarchy-menu";
          "on-click-right" = "xdg-terminal-exec";
          "tooltip-format" = "Omarchy Menu\n\nSuper + Alt + Space";
        };

        "custom/update" = {
          "format" = "";
          "exec" = "omarchy-update-available";
          "on-click" = "omarchy-launch-floating-terminal-with-presentation omarchy-update";
          "tooltip-format" = "Omarchy update available";
          "signal" = 7;
          "interval" = 21600;
        };

        "cpu" = {
          "interval" = 5;
          "format" = "󰍛";
          "on-click" = "xdg-terminal-exec btop";
        };

        "clock" = {
          "format" = "{:%H:%M}";
          "format-alt" = "{:%a, %d %b %H:%M}";
          "tooltip" = false;
          "on-click-right" = "omarchy-launch-floating-terminal-with-presentation omarchy-tz-select";
        };

        "network" = {
          "format-wifi" = "{essid} ({signalStrength}%)  ";
          "format-ethernet" = "5G   ";
          "format-disconnected" = "Disconnected ⚠";
        };

        "battery" = {
          "format" = "{capacity}% {icon} ";
          "format-icons" = [ "" "" "" "" "" ];
        };

        "custom/battery" = {
          "format" = "100%   ";
          "tooltip" = false;
        };

        "bluetooth" = {
          "format" = "";
          "format-disabled" = "󰂲";
          "format-connected" = "";
          "tooltip-format" = "Devices connected: {num_connections}";
          "on-click" = "blueberry";
        };

        "pulseaudio" = {
          "format" = "{volume}%  {icon} ";
          "on-click" = "xdg-terminal-exec --app-id=com.omarchy.Wiremix -e wiremix";
          "on-click-right" = "pamixer -t";
          "tooltip-format" = "Playing at {volume}%";
          "scroll-step" = 5;
          "format-muted" = "";
          "format-icons" = {
            "default" = [ "" "" "" ];
          };
        };

        "mpris" = {
          "format" = "{player_icon}     {artist} / {title}";
          "format-paused" = "{player_icon}   Paused";
          "player-icons" = {
            "default" = "▶";
            "mpv" = "🎵";
            "spotify" = "";
            "firefox" = "";
          };
          "status-icons" = {
            "paused" = "■";
          };
          "ignored-players" = [ "firefox" ];
          "max-length" = 35;
          "interval" = 1;
          "on-click" = "playerctl play-pause";
          "on-click-right" = "playerctl next";
          "on-click-middle" = "playerctl previous";
        };

        "group/tray-expander" = {
          "orientation" = "inherit";
          "drawer" = {
            "transition-duration" = 600;
            "children-class" = "tray-group-item";
          };
          "modules" = [ "custom/expand-icon" "tray" ];
        };

        "custom/expand-icon" = {
          "format" = "";
          "tooltip" = false;
        };

        "custom/screenrecording-indicator" = {
          "on-click" = "omarchy-cmd-screenrecord";
          "exec" = "$OMARCHY_PATH/default/waybar/indicators/screen-recording.sh";
          "signal" = 8;
          "return-type" = "json";
        };

        "tray" = {
          "icon-size" = 12;
          "spacing" = 17;
        };
      };
    };
    style = ''
      * {
          color: #fbf1c7;
          border: none;
          min-height: 0;
          margin: 0;
          padding: 0;
          font-family: "SF Pro Rounded", "JetBrainsMonoNL Nerd Font";
          font-size: 15px;
          font-weight: 700;
      }

      #waybar {
          background: transparent;
      }

      .modules-left {
          margin-left: 0px;
      }

      .modules-right {
          margin-right: 0px;
      }

      #workspaces {
          background: rgba(0, 0, 0, 0);
          border-radius: 0px;
          padding: 0px 4px;
          margin-top: 5px;
          margin-bottom: 5px;
          margin-right: 10px;
      }

      #workspaces button {
          background: rgba(40, 40, 40, 1);
          color: #fbf1c7;
          border: 1px solid #282828;
          box-shadow: 0 1 0 2 #282828;
          border-radius: 0px;
          padding: 0px 4px;
          margin: 0 4px;
          transition: all 0.2s ease;
      }

      #workspaces button.active {
          background: rgba(54, 54, 54, 1);
          border-radius: 0px;
          margin: 0 4px;
          min-width: 40px;
      }

      #workspaces button:hover {
          background: #888888;
          color: #000000;
      }

      #workspaces button.empty {
          opacity: 0.5;
      }

      #network,
      #pulseaudio,
      #custom-battery,
      #battery,
      #clock,
      #mpris {
          background-color: rgba(40, 40, 40, 1);
          border-radius: 0px;
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
          color: #a6e3a1;
          border-color: #a6e3a1;
      }

      #network.disconnected {
          color: #f38ba8;
          border-color: #f38ba8;
      }

      #custom-expand-icon {
          margin-right: 20px;
      }

      tooltip {
          padding: 2px;
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
          color: #a55555;
      }
    '';
  };
}
