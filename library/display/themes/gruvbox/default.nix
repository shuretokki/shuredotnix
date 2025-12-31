# https://github.com/morhetz/gruvbox
{ pkgs }: {
  scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  polarity = "dark";

  wallpaperDir = "gruvbox";  # ~/Wallpapers/gruvbox/

  fonts = {
    mono = "JetBrainsMono Nerd Font";
    sans = "SF Pro Rounded";
    size = 12;
  };

  cursor = {
    name = "macOS";
    size = 24;
  };

  appearance = {
    rounding = 10;
    blur = true;
    shadows = true;
    border_size = 2;
  };
}
