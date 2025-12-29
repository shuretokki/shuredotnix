{ lib, pkgs, vars, ... }: {
  programs.bash = {
    enable = lib.mkDefault true;

    shellAliases = {
      rebuild = lib.mkDefault "sudo nixos-rebuild switch --flake .";
      rebuild-test = lib.mkDefault "sudo nixos-rebuild test --flake .";
      rebuild-boot = lib.mkDefault "sudo nixos-rebuild boot --flake .";
      rebuild-dry = lib.mkDefault "nixos-rebuild dry-build --flake .";

      update = lib.mkDefault "nix flake update";
      check = lib.mkDefault "nix flake check";
      fmt = lib.mkDefault "nix fmt";

      gc = lib.mkDefault "sudo nix-collect-garbage -d";
      gc-week = lib.mkDefault "sudo nix-collect-garbage --delete-older-than 7d";
      gc-month = lib.mkDefault "sudo nix-collect-garbage --delete-older-than 30d";

      nix-size = lib.mkDefault "nix path-info -Sh /run/current-system";
      nix-store-size = lib.mkDefault "du -sh /nix/store";

      generations = lib.mkDefault "sudo nix-env --list-generations -p /nix/var/nix/profiles/system";
      gen-diff = lib.mkDefault "nvd diff /run/current-system /nix/var/nix/profiles/system";

      cdnix = lib.mkDefault "cd ~/shuredotnix";
      dev = lib.mkDefault "nix develop";
    };

    profileExtra = lib.mkDefault ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };
}
