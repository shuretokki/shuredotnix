# https://wiki.nixos.org/wiki/Flakes
# https://nix.dev/manual/nix/stable/command-ref/new-cli/nix3-flake

{
  description = "NixOS Configuration";

  # binary caches for faster builds.
  # extra-substituters appends to system substituters (doesn't override).
  # without matching public keys, nix silently ignores the cache.
  nixConfig = {
    extra-substituters = [
      "https://shuredotnix.cachix.org"
      "https://hyprland.cachix.org"
      "https://vicinae.cachix.org"
    ];
    extra-trusted-public-keys = [
      "shuredotnix.cachix.org-1:rmlHcxqncZqjzGscGzHhYUctuGc3bQEte7Lh1PkO0Xc="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    vicinae-extensions.url = "github:vicinaehq/extensions";
    vicinae-extensions.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixcord.url = "github:kaylorben/nixcord";
    nixcord.inputs.nixpkgs.follows = "nixpkgs";

    youtube-music.url = "github:h-banii/youtube-music-nix";
    youtube-music.inputs.nixpkgs.follows = "nixpkgs";

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    apple-fonts.inputs.nixpkgs.follows = "nixpkgs";

    antigravity.url = "github:jacopone/antigravity-nix";
    antigravity.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      repo = "dotnix";
      alias = "sdn";
      utils = import ./utils { inherit inputs; };
      identity = import ./identity.nix;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      devShells.x86_64-linux = import ./shells.nix {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };

      # merges custom packages (pkgs/) with system builds (hosts/).
      # custom: `nix build .#<pkg>` (e.g. `nix build .#sdn-update`)
      # system: `nix build .#desktop` (used by ci to verify builds)
      # TODO: research nix-fast-build or devour-flake
      packages.x86_64-linux =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          sdnpkgs = import ./pkgs { inherit pkgs repo alias; };
          syspkgs = nixpkgs.lib.mapAttrs (
            hostname: config: config.config.system.build.toplevel
          ) self.nixosConfigurations;
        in
        sdnpkgs // syspkgs;

      overlays = import ./overlays { inherit inputs repo alias; };

      # auto-discovers hosts by reading directories in hosts/.
      # adding a new host only requires creating hosts/<name>/default.nix,
      # no need to manually register it here.
      nixosConfigurations =
        let
          lib = nixpkgs.lib;
          hostDirs = lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./hosts);
        in
        lib.genAttrs (builtins.attrNames hostDirs) (
          hostname:
          utils.mkHost {
            inherit hostname repo alias;
            username = identity.username;
            overlays = [
              self.overlays.additions
              self.overlays.modifications
            ];
          }
        );
    };
}
