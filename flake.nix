{
  description = "system config";

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
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    utils = import ./utils { inherit inputs; };
    vars = import ./vars.nix;
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      packages = with nixpkgs.legacyPackages.x86_64-linux; [
        sops age cachix
        gcc gnumake
        nodejs python3
        flake-checker
      ];
      shellHook = ''
        if [ ! -f .git/hooks/pre-commit ]; then
          echo "Installing git hooks..."
          mkdir -p .git/hooks
          cp .git-hooks/pre-commit .git/hooks/pre-commit
          chmod +x .git/hooks/pre-commit
        fi
      '';
    };

    nixosConfigurations = let
      lib = nixpkgs.lib;
      hostDirs = lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./hosts);
    in lib.genAttrs (builtins.attrNames hostDirs) (hostname:
      utils.mkHost { inherit hostname; username = vars.username; }
    );

    packages.x86_64-linux = nixpkgs.lib.mapAttrs
      (hostname: config: config.config.system.build.toplevel)
      self.nixosConfigurations;
  };
}
