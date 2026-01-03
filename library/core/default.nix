{ lib, vars, ... }:
{
  imports = [
    ./locale.nix
    ./boot.nix
    ./network.nix
    ./security.nix
    ./performance.nix
    ./system.nix
    ./sops.nix
  ]
  ++ lib.optionals vars.features.desktop [
    ./audio.nix
    ./bluetooth.nix
    ./fonts.nix
    ./input.nix
    ./files.nix
  ];
}
