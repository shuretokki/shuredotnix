# https://stylix.danth.me/
{ lib, pkgs, vars, ... }:
let
  themeDir = ./themes + "/${vars.theme}";
  themeData = import (themeDir + "/default.nix") { inherit pkgs; };
in {
  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = themeData.scheme;

    image = themeDir + "/wallpapers/" + themeData.wallpaperDefault;
    polarity = themeData.polarity;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = lib.mkForce themeData.fonts.mono;
      };
      sansSerif = {
        package = pkgs.inter;
        name = themeData.fonts.sans;
      };
      sizes = {
        terminal = lib.mkDefault themeData.fonts.size;
        applications = 11;
      };
    };

    cursor = {
      package = pkgs.apple-cursor;
      name = lib.mkDefault themeData.cursor.name;
      size = lib.mkDefault themeData.cursor.size;
    };

    targets.grub.enable = false;
  };

  # auto-update wallpaper symlink on rebuild
  home.activation.linkWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${builtins.unsafeDiscardStringContext (toString ~/Wallpapers)}"
    ln -sfn "${themeDir}/wallpapers" "${builtins.unsafeDiscardStringContext (toString ~/Wallpapers)}/current"
  '';

  home-manager.users.${vars.username}.stylix.targets = {
    vscode.enable = lib.mkDefault false;
    hyprpaper.enable = lib.mkDefault false;
    zen-browser.profileNames = [ "default" ];
  };
}
