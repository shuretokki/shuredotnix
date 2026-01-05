{ config, lib, pkgs, vars, ... }:
let
  cfg = config.library.core.virtualisation;
in
{
  options.library.core.virtualisation = {
    docker.enable = lib.mkEnableOption "Docker container runtime";
    podman.enable = lib.mkEnableOption "Podman container runtime";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.docker.enable {
      virtualisation.docker.enable = true;
      users.users.${vars.username}.extraGroups = [ "docker" ];
    })

    (lib.mkIf cfg.podman.enable {
      virtualisation.podman = {
        enable = true;
        dockerCompat = !cfg.docker.enable; # Use podman as docker if docker is disabled
      };
      # Podman typically works rootless or via subuid/subgid, but adding to group doesn't hurt for socket access if needed
    })
  ];
}
