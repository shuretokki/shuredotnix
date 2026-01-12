{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./gpu.nix
    ./boot.nix
    ../../library/core
    ../../library/profiles/desktop
  ];

  system.stateVersion = "26.05";
  networking.hostName = "desktop-b";
}
