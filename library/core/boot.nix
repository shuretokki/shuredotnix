{ lib, pkgs, vars, ... }:
let
  # Import Theme Config using relative path since this is in core/
  # Ideally we should use a consistent method, but assuming library folder structure:
  # library/core/boot.nix -> ../display/themes
  themeDir = ../display/themes + "/${vars.theme}";
  themeGrub = if builtins.pathExists (themeDir + "/grub.nix")
              then import (themeDir + "/grub.nix") { inherit pkgs; }
              else {};

  # Fallback Default Theme
  defaultTheme = pkgs.stdenv.mkDerivation {
        pname = "wuthering-grub-theme";
        version = "1.0";
        src = pkgs.fetchFromGitHub {
            owner = "vinceliuice";
            repo = "Wuthering-grub2-themes";
            rev = "ed3f8bcd292e7a0684f3c30f20939710d263a321";
            sha256 = "sha256-q9TLZTZI/giwKu8sCTluxvkBG5tyan7nFOqn4iGLnkA=";
        };
        installPhase = ''
            mkdir -p $out
            cp -a $src/common/*.pf2 $out/
            cp -a $src/config/theme-1080p.txt $out/theme.txt
            cp -a $src/backgrounds/background-jinxi.jpg $out/background.jpg
            cp -a $src/assets/assets-icons/icons-1080p $out/icons
            cp -a $src/assets/assets-other/other-1080p/*.png $out/
        '';
  };
in {
    boot.loader.systemd-boot.enable = false;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        theme = lib.mkForce (if themeGrub ? loaderTheme then themeGrub.loaderTheme else defaultTheme);
    };
}