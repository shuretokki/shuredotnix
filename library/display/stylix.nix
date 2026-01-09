# https://stylix.danth.me/
# TODO: consider matugen for dynamic color scheme from wallpaper
#       requires research on current stylix integration and matugen setup

{ lib, pkgs, identity, config, ... }:
let
  wpBase = config.theme.wallpaperDir;
in
{
  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = config.theme.scheme;
    image = config.theme.wallpaper;
    polarity = config.theme.polarity;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;

        # stylix auto-sets name from package
        # but we want theme override
        name = lib.mkForce config.theme.fonts.mono;
      };
      sansSerif = {
        package = pkgs.inter;
        name = config.theme.fonts.sans;
      };
      sizes = {
        terminal = lib.mkDefault config.theme.fonts.size;
        applications = 11;
      };
    };

    cursor = {
      package = pkgs.apple-cursor;
      name = lib.mkDefault config.theme.cursor.name;
      size = lib.mkDefault config.theme.cursor.size;
    };

    targets.grub.enable = false;
  };

  # loads base theme options then overlays
  # user-selected theme from identity.nix
  imports = [
    ./themes/default.nix
    (./themes + "/${identity.theme}/default.nix")
  ];

  home-manager.users.${identity.username} = { config, lib, ... }: {
    # these apps have custom theming or stylix breaks them
    stylix.targets = {
      vscode.enable = lib.mkDefault false;
      hyprpaper.enable = lib.mkDefault false;
      spicetify.enable = false;
      waybar.enable = false;
      swaync.enable = false;
      zen-browser.profileNames = [ "default" ];
    };

    # bootstrap awww wallpapers directory with base wallpapers
    home.activation.bootstrapWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      DIR="${config.home.homeDirectory}/.local/share/awww"
      mkdir -p "$DIR"

      # copy base wallpapers (if they don't exist)
      for f in ${wpBase}/*; do
        name=$(basename "$f")
        [ ! -e "$DIR/$name" ] && cp "$f" "$DIR/$name"
      done
    '';
  };
}
