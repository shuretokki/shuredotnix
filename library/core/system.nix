{ config, pkgs, vars, inputs, ... }: {
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = ["nix-command" "flakes"];
  };

  networking.hostName = vars.hostname;

  programs.dconf.enable = true;
  services.gvfs.enable = vars.features.desktop;
  services.udisks2.enable = vars.features.desktop;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/${vars.username}/shuredotnix";
  };

  xdg.portal = {
    enable = vars.features.desktop;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
