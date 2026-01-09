# https://wiki.nixos.org/wiki/Docker
# https://wiki.nixos.org/wiki/Podman
# https://search.nixos.org/options?query=virtualisation.docker
# https://search.nixos.org/options?query=virtualisation.podman

{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
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
      # socket access requires group membership
      users.users.${vars.username}.extraGroups = [ "docker" ];
    })

    (lib.mkIf cfg.podman.enable {
      virtualisation.podman = {
        enable = true;
        # emulate docker CLI when docker is disabled
        dockerCompat = !cfg.docker.enable;
      };

      # podman typically works rootless or via subuid/subgid,
      # but adding to group doesn't hurt for socket access if needed
    })
  ];
}
