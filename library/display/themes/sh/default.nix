{ pkgs, ... }: {
  theme = {
    hyprland = {
      rounding = 12;
      gaps-in = 6;
      gaps-out = 10;
      blur = true;
      shadows = true;
      active-border-col = "rgba(1e1e1eff) rgba(0a84ffff) 45deg";
      inactive-border-col = "rgba(595959aa)";
    };

    hyprlock = {
      fontFamily = "SF Pro Rounded";
      fontSize = 64;
    };
  };
}
