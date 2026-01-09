# https://wiki.nixos.org/wiki/Fonts
# https://search.nixos.org/options?query=fonts

{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.library.core.fonts;
in
{
  options.library.core.fonts = {
    enable = lib.mkEnableOption "Font configuration and packages";
  };

  config = lib.mkIf cfg.enable {
    # create a directory with links to all fonts
    # at /run/current-system/sw/share/X11/fonts
    fonts.fontDir.enable = true;

    # enable a basic set of default fonts
    # Dejavu, FreeFont, Gyre, Liberation, Unifont, Noto Color Emoji.
    fonts.enableDefaultPackages = true;

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      fira
      source-han-sans
      source-han-serif
      inter
      eb-garamond

      nerd-fonts.jetbrains-mono

      inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro
      inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-mono
      inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.ny
    ];

    fonts.fontconfig = {
      enable = true;

      # enable font antialiasing (smoothing)
      # default: true
      antialias = true;

      # enable font hinting (aligning glyphs to pixel boundaries)
      # improves rendering at low resolutions
      hinting = {
        enable = true;
        autohint = false;
        # hinting style: "none", "slight", "medium", "full"
        style = "slight";
      };

      subpixel = {
        # LCD filter: "none", "default", "light", "legacy"
        lcdfilter = "default";
        # subpixel layout: "none", "rgb", "bgr", "vrgb", "vbgr"
        rgba = "rgb";
      };

      defaultFonts = {
        serif = [ config.theme.fonts.serif "Liberation Serif" "Noto Serif" ];
        sansSerif = [ config.theme.fonts.sans "SF Pro Rounded" "Inter" "Noto Sans" ];
        monospace = [ config.theme.fonts.mono "JetBrainsMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
