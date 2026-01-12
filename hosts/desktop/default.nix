# desktop host configuration.
# imports core modules and desktop profile.
# hardware-specific toggles (nvidia, docker) set here.

{ config, pkgs, identity, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./gpu.nix
    ./boot.nix
    ../../library/core
    ../../library/profiles/desktop
  ];

  # library.core.gpu.nvidia.open = false; # Example override
  library.core.virtualisation.docker.enable = true;

  system.stateVersion = "25.11";
}
