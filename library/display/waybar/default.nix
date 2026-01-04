{ config, pkgs, vars, lib, ... }:
let
  colors = config.lib.stylix.colors;

  # base config can be here, or fully driven by theme.
  # using mkMerge to allow theme to override/extend settings.
  baseSettings = {
      mainBar = {
        "reload_style_on_change" = true;
        "layer" = "top";
        "position" = "top";
        "height" = 26;
        "margin-top" = 4;
        "margin-left" = 0;
        "margin-right" = 0;
        "spacing" = 0;
        "modules-left" = [ "hyprland/workspaces" ];
        "modules-center" = [ "mpris" ];
        "modules-right" = [ "network" "pulseaudio" "desktop/battery" "clock" ];

        "hyprland/workspaces" = {
          "on-click" = "activate";
          "active-only" = false;
          "all-outputs" = true;
          "format" = "{name}";
          "persistent-workspaces" = { "*" = 5; };
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
          "format-wifi" = "{essid} ({signalStrength}%)  ";
          "format-ethernet" = "5G   ";
          "format-disconnected" = "Disconnected ⚠";
        };
        "pulseaudio" = {
          "format" = "{volume}% {icon} ";
          "on-click" = "xdg-terminal-exec --app-id=com.omarchy.Wiremix -e wiremix";
          "on-click-right" = "pamixer -t";
          "tooltip-format" = "Playing at {volume}%";
          "scroll-step" = 5;
          "format-muted" = "";
          "format-icons" = { "default" = [ "" "" "" ]; };
        };
        "desktop/battery" = {
          "format" = "100%  ";
          "tooltip" = false;
        };
        "battery" = {
          "format" = "{capacity}% {icon} ";
          "format-icons" = [ "" "" "" "" "" ];
        };
        "clock" = {
          "format" = "{:%H:%M}";
          "format-alt" = "{:%a, %d %b %H:%M}";
          "tooltip" = false;
        };
        "mpris" = {
          "format" = "{player_icon}  {artist} / {title}";
          "format-paused" = "{player_icon}   Paused";
          "player-icons" = {
            "default" = "▶";
            "mpv" = "🎵";
            "spotify" = "";
            "firefox" = "";
          };
          "status-icons" = { "paused" = "■"; };
          "ignored-players" = [ "firefox" ];
          "max-length" = 35;
          "interval" = 1;
          "on-click" = "playerctl play-pause";
          "on-click-right" = "playerctl next";
          "on-click-middle" = "playerctl previous";
        };
      };
  };
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # merge base settings with theme-specific config
    settings = lib.mkMerge [ baseSettings config.theme.waybar.config ];

    style = ''
      * {
          font-family: "${config.stylix.fonts.monospace.name}";
          font-size: 15px;
          font-weight: 700;
          border: none;
          min-height: 0;
          margin: 0;
          padding: 0;
      }

      window#waybar {
          background: transparent;
      }

      .modules-left {
          margin-left: 0px;
      }

      .modules-right {
          margin-right: 0px;
      }

      #workspaces {
          border-radius: 0px;
          padding: 0px 4px;
          margin-top: 5px;
          margin-bottom: 5px;
          margin-right: 10px;
      }

      #workspaces button {
          background: #${colors.base00};
          color: #${colors.base05};
          border: 1px solid #${colors.base01};
          box-shadow: 0 1 0 2 #${colors.base01};
          border-radius: 0px;
          padding: 0px 4px;
          margin: 0 4px;
          transition: all 0.2s ease;
      }

      #workspaces button.active {
          background: #${colors.base01};
          border-radius: 0px;
          margin: 0 4px;
          min-width: 40px;
      }

      #workspaces button.urgent {
          background: #${colors.base08};
          color: #${colors.base00};
      }

      #workspaces button.empty {
          opacity: 0.5;
      }

      #network,
      #pulseaudio,
      #desktop-battery,
      #battery,
      #clock,
      #mpris {
          background: #${colors.base00};
          border-radius: 0px;
          padding: 0px 4px;
          margin-top: 5px;
          margin-bottom: 5px;
          margin-right: 5px;
      }

      #mpris { padding: 0px 32px; }
      #clock { font-weight: 700; }

      #battery.charging, #battery.plugged { color: #${colors.base0B}; }
      #network.disconnected { color: #${colors.base08}; }

      tooltip {
          padding: 2px;
          background: #${colors.base00};
          border: 1px solid #${colors.base0D};
          border-radius: 0px;
      }
      tooltip label { color: #${colors.base05}; }

      ${config.theme.waybar.style}
    '';
  };
}
