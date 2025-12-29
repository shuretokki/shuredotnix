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
        nixpkgs.url = "nixpkgs/nixos-unstable";
        hyprland.url = "github:hyprwm/Hyprland";
        vicinae.url = "github:vicinaehq/vicinae";

        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
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
            inputs = {
                # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
                # to have it up-to-date or simply don't specify the nixpkgs input
                nixpkgs.follows = "nixpkgs";
                home-manager.follows = "home-manager";
            };
        };

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        apple-fonts = {
            url = "github:Lyndeno/apple-fonts.nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

    };

    outputs = { self, nixpkgs, home-manager, vicinae, apple-fonts, ... }@inputs:
    let
        vars = import ./vars.nix;

        mkSystem = { hostname, username, hostConfigDir, userConfigDir, system ? "x86_64-linux" }:
            let
                hostConfig = hostConfigDir + "/default.nix";
                hardwareConfig = hostConfigDir + "/hardware-configuration.nix";
                userHomeConfig = userConfigDir + "/home.nix";
                userNixosConfig = userConfigDir + "/nixos.nix";
            in
            assert (builtins.isString hostname && hostname != "");
            assert (builtins.isString username && username != "");

            if ! (builtins.pathExists hostConfig) then builtins.abort "host config not found at ${hostConfig}"
            else if ! (builtins.pathExists hardwareConfig) then builtins.abort "hardware config not found at ${hardwareConfig}"
            else if ! (builtins.pathExists userHomeConfig) then builtins.abort "user home config not found at ${userHomeConfig}"
            else if ! (builtins.pathExists userNixosConfig) then builtins.abort "user nixos config not found at ${userNixosConfig}"
            else
            nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs; vars = vars // { inherit hostname username; }; };
                modules = [
                    hostConfig
                    userNixosConfig
                    home-manager.nixosModules.home-manager {
                        home-manager = {
                            useGlobalPkgs = true;
                            useUserPackages = true;
                            extraSpecialArgs = { inherit inputs; vars = vars // { inherit hostname username; }; };
                            sharedModules = [ vicinae.homeManagerModules.default ];
                            users.${username} = import userHomeConfig;
                            backupFileExtension = "backup";
                        };
                    }
                ];
            };
    in {
        nixosConfigurations = {
            # default configuration
            default = mkSystem {
                inherit (vars) hostname username;
                hostConfigDir = ./hosts/desktop;
                userConfigDir = ./users/shure;
            };

            # template for new users:
            # user-pc = mkSystem {
            #     hostname = "user-pc";
            #     username = "user";
            #     hostConfigDir = ./hosts/user-pc;
            #     userConfigDir = ./users/user;
            # };
        };
    };
}
