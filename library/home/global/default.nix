# Home Manager Global Defaults
# https://nix-community.github.io/home-manager/
{ lib, vars, ... }: {
  imports =
    lib.optionals vars.features.cli [ ../bundlers/cli ]
    ++ lib.optionals vars.features.desktop [ ../bundlers/desktop ];

  xdg.enable = lib.mkDefault true;

  news.display = "silent";
}
