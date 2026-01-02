{ config, pkgs, vars, inputs, ... }: {
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://hyprland.cachix.org"
      "https://vicinae.cachix.org"
    ];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
  };

  networking.hostName = vars.hostname;
  console.keyMap = "us";

  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/${vars.username}/shuredotnix";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
