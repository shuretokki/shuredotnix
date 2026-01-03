# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/fonts/fontdir.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/fonts/fontconfig.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/fonts/packages.nix

{ config, pkgs, inputs, ... }: {
  # Create a directory with links to all fonts
  # at /run/current-system/sw/share/X11/fonts
  fonts.fontDir.enable = true;

  # Enable a basic set of default fonts
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

    # Enable font antialiasing (smoothing)
    # Default: true
    antialias = true;

    # Enable font hinting (aligning glyphs to pixel boundaries)
    # Improves rendering at low resolutions
    hinting = {
      enable = true;
      autohint = false;
      # Hinting style: "none", "slight", "medium", "full"
      style = "slight";
    };

    subpixel = {
      # LCD filter: "none", "default", "light", "legacy"
      lcdfilter = "default";
      # Subpixel layout: "none", "rgb", "bgr", "vrgb", "vbgr"
      rgba = "rgb";
    };

    defaultFonts = {
      serif = [ config.theme.fonts.serif "Liberation Serif" "Noto Serif" ];
      sansSerif = [ config.theme.fonts.sans "SF Pro Rounded" "Inter" "Noto Sans" ];
      monospace = [ config.theme.fonts.mono "JetBrainsMono Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
