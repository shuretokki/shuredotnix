{
    description = "system config";

    nixConfig = {
        extra-substituters = [
            "https://hyprland.cachix.org"
            "https://vicinae.cachix.org"
        ];
        extra-trusted-public-keys = [
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        ];
    };

    inputs = {
        antigravity = {
            url = "github:jacopone/antigravity-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        apple-fonts = {
            url = "github:Lyndeno/apple-fonts.nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixpkgs = {
            url = "nixpkgs/nixos-unstable";
        };

        hyprland = {
            url = "github:hyprwm/Hyprland";
        };

        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
        };

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        vicinae-extensions = {
            url = "github:vicinaehq/extensions";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        spicetify-nix = {
            url = "github:Gerg-L/spicetify-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };


        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        stylix = {
            url = "github:danth/stylix";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };

        nixcord = {
            url = "github:kaylorben/nixcord";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        youtube-music = {
            url = "github:h-banii/youtube-music-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-hardware = {
            url = "github:NixOS/nixos-hardware";
        };
    };

    outputs = { self, nixpkgs, ... }@inputs:
    let
        libs = import ./lib { inherit inputs; };
    in {

        # dev shell that run using 'nix develop'
        devShells.x86_64-linux.default = let
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in pkgs.mkShell {
            packages = with pkgs; [ sops age ];
            shellHook = ''
            '';
        };

        # we find each directory in ./hosts
        # and generate a nixos configuration for it
        nixosConfigurations = let
            hosts = ./hosts;
            vars = import ./vars.nix;
            lib = nixpkgs.lib;

            dir = builtins.attrNames
                (lib.filterAttrs (n: v: v == "directory") (builtins.readDir hosts));

            config = hostname: libs.mkHost {
                inherit hostname;
            };
        in
            lib.genAttrs dir config;
    };
}
