# https://wiki.hypr.land/Configuring/Binds/
{ pkgs, ... }:
    let
        super = "SUPER";
        alt = "ALT";
        shift = "SHIFT";
        ctrl = "CTRL";

        terminal = "warp-terminal";
        browser = "zen";
        fileManager = "${pkgs.nautilus}/bin/nautilus";

        launch = class: cmd: "exec, hyprctl clients | grep -i 'class: ${class}' && hyprctl dispatch focuswindow 'class:${class}' || ${cmd}";

    in [
        "${super}, RETURN, exec, uwsm app -- ${terminal}"
        "${super}, E, exec, uwsm app -- ${fileManager} --new-window"
        "${super}, B, exec, uwsm app -- ${browser}"

        "${super}, M, ${launch "Spotify" "uwsm app -- ${pkgs.spotify}/bin/spotify"}"
        "${super}, N, exec, uwsm app -- ${terminal} -e nvim"
        "${super}, T, exec, uwsm app -- ${terminal} -e btop"

        "${alt}, SPACE, exec, ${pkgs.vicinae}/bin/vicinae show"

        # Closing Windows
        "${alt} ${ctrl} ${shift}, W, killactive"

        # Toggle Floating/Tiling
        "${alt}, Q, togglefloating"

        # Fullscreen
        "${alt}, F, fullscreen, 1" # 1 = Keep gaps (Maximize)

        # "Pop Out" (Float + Pin)
        "${alt}, O, togglefloating"
        "${alt}, O, pin"

        # Focus Movement (WASD)
        "${alt}, A, movefocus, l"
        "${alt}, D, movefocus, r"
        "${alt}, W, movefocus, u"
        "${alt}, S, movefocus, d"

        # Window Swapping (WASD + SHIFT)
        "${alt} ${shift}, A, swapwindow, l"
        "${alt} ${shift}, D, swapwindow, r"
        "${alt} ${shift}, W, swapwindow, u"
        "${alt} ${shift}, S, swapwindow, d"

        # Resizing (Shift + C/V)
        "${alt} ${shift}, C, resizeactive, -100 0"
        "${alt} ${shift}, V, resizeactive, 100 0"

        # Switch
        "${alt}, 1, workspace, 1"
        "${alt}, 2, workspace, 2"
        "${alt}, 3, workspace, 3"
        "${alt}, 4, workspace, 4"
        "${alt}, 5, workspace, 5"
        "${alt}, 6, workspace, 6"
        "${alt}, 7, workspace, 7"
        "${alt}, 8, workspace, 8"
        "${alt}, 9, workspace, 9"
        "${alt}, 0, workspace, 10"

        # Move Window to Workspace
        "${alt} ${shift}, 1, movetoworkspace, 1"
        "${alt} ${shift}, 2, movetoworkspace, 2"
        "${alt} ${shift}, 3, movetoworkspace, 3"
        "${alt} ${shift}, 4, movetoworkspace, 4"
        "${alt} ${shift}, 5, movetoworkspace, 5"
        "${alt} ${shift}, 6, movetoworkspace, 6"
        "${alt} ${shift}, 7, movetoworkspace, 7"
        "${alt} ${shift}, 8, movetoworkspace, 8"
        "${alt} ${shift}, 9, movetoworkspace, 9"
        "${alt} ${shift}, 0, movetoworkspace, 10"

        # Vicinae
        "${alt}, SPACE, exec, vicinae toggle"

        # Media Keys (using playerctl)
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"

        # Volume Keys (using swayosd)
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"

        # Brightness Keys (using swayosd)
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"

        # Screenshots (using hyprshot)
        ", Print, exec, hyprshot -m output"
        "${super} ${shift}, W, exec, hyprshot -m window"
        "${super} ${shift}, Q, exec, hyprshot -m region"

        "${super}, G, exec, toggle-gaps"

        # Toggle Waybar
        "${super}, W, exec, pkill -USR1 waybar"

        # Lock Screen
        "${super}, L, exec, hyprlock"
    ]