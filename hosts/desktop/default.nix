# desktop host configuration.
# imports core modules and desktop profile.
# hardware-specific toggles (nvidia, docker) set here.

{ config, pkgs, vars, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../library/core
    ../../library/profiles/desktop
  ];

  library.core.gpu.nvidia.enable = true;
  library.core.gpu.nvidia.open = false;
  library.core.virtualisation.docker.enable = true;

  system.stateVersion = "25.11";
}
