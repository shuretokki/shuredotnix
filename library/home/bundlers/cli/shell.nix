{
  lib,
  pkgs,
  vars,
  ...
}:
{
  programs.bash = {
    enable = lib.mkDefault true;

    shellAliases = {
      rebuild = lib.mkDefault "nh os switch ~/shuredotnix";
      rebuild-test = lib.mkDefault "nh os test ~/shuredotnix";
      rebuild-boot = lib.mkDefault "nh os boot ~/shuredotnix";
      rebuild-vm = lib.mkDefault "nh os build-vm ~/shuredotnix";

      update = lib.mkDefault "cd ~/shuredotnix && nix flake update";
      check = lib.mkDefault "cd ~/shuredotnix && nix flake check";
      fmt = lib.mkDefault "cd ~/shuredotnix && nix fmt";

      nix-size = lib.mkDefault "nix path-info -Sh /run/current-system";
      nix-store-size = lib.mkDefault "du -sh /nix/store";

      generations = lib.mkDefault "sudo nix-env --list-generations -p /nix/var/nix/profiles/system";
      gen-diff = lib.mkDefault "nvd diff /run/current-system /nix/var/nix/profiles/system";

      cdnix = lib.mkDefault "cd ~/shuredotnix";
      dev = lib.mkDefault "nix develop";

      gs = "git status";
      gd = "git diff";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";
      gl = "git log --oneline --graph --decorate";
      gla = "git log -1 HEAD";
      gco = "git checkout";
    };

    profileExtra = lib.mkDefault ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };
}
