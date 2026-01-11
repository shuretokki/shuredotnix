{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./gpu.nix
    ./boot.nix
    ../../library/core
    ../../library/profiles/''${profile}
  ];

  system.stateVersion = "''${stateVersion}";
}
