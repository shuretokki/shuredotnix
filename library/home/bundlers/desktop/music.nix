# Music Applications
# https://github.com/Gerg-L/spicetify-nix
{ lib, pkgs, config, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  colors = config.lib.stylix.colors.withHashtag;
in {
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = lib.mkDefault true;
    theme = lib.mkDefault spicePkgs.themes.text;
    colorScheme = lib.mkForce "custom";
    customColorScheme = {
      text = colors.base05;
      subtext = colors.base04;
      main = colors.base00;
      sidebar = colors.base01;
      player = colors.base02;
      card = colors.base02;
      shadow = colors.base00;
      selected-row = colors.base03;
      button = colors.base0D;
      button-active = colors.base0C;
      button-disabled = colors.base03;
      tab-active = colors.base0D;
      notification = colors.base0B;
      notification-error = colors.base08;
      misc = colors.base04;
    };
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
      adblock
    ];
  };

  home.packages = with pkgs; [ youtube-music ];
}

