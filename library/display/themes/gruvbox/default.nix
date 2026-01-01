{ pkgs, ... }: {
  theme = {
    scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    polarity = "dark";

    fonts = {
      mono = "JetBrainsMono Nerd Font";
      sans = "SF Pro Rounded";
      size = 12;
    };

    cursor = {
      name = "macOS";
      size = 24;
    };

    wallpaper = "";

    hyprland = {
      rounding = 0;
      gaps-in = 4;
      gaps-out = 4;
      blur = true;
      shadows = true;
      active-border-col = "rgba(fabd2fee) rgba(b8bb26ee) 45deg";
      inactive-border-col = "rgba(504945aa)";
    };

    waybar.style = ''
      #workspaces, #network, #pulseaudio, #battery, #clock, #mpris {
        border-radius: 0px;
      }
      #workspaces button {
        border-radius: 0px;
      }
    '';

    hyprlock = {
      fontFamily = "SF Pro Rounded";
      fontSize = 64;
      input-field = {
        size = "300, 50";
        outline_thickness = 2;
        dots_size = 0.33;
        dots_spacing = 0.15;
      };
    };
  };
}
