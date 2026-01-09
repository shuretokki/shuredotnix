# https://github.com/sharkdp/bat
# https://home-manager-options.extranix.com/?query=programs.bat

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
