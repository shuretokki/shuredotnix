{ lib, pkgs, vars, ... }: {
  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/AngelJumbo/gruvbox-wallpapers/refs/heads/main/wallpapers/mix/gruvbox_scenery.png";
      sha256 = "07187428f731e84764836ac4288012674209581895a9829281519ef16fb41e4d";
    };

    polarity = "dark";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = lib.mkDefault vars.fontMono;
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      sizes = {
        terminal = lib.mkDefault vars.fontSize;
        applications = 11;
      };
    };

    cursor = {
      package = pkgs.apple-cursor;
      name = lib.mkDefault vars.cursorTheme;
      size = lib.mkDefault vars.cursorSize;
    };
  };
}
