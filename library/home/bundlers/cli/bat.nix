# https://github.com/nix-community/home-manager/blob/master/modules/programs/bat.nix

{ lib
, pkgs
, ...
}:
{
  programs.bat = {
    enable = lib.mkDefault true;

    config = {
      style = "numbers,changes,header";
      pager = "less -FR";
      italic-text = "always";
      wrap = "auto";
    };

    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];

    themes = { };
    syntaxes = { };
  };
}
