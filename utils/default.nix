{ inputs }:
let
  lib = inputs.nixpkgs.lib;
  identity = import ../identity.nix;
in
{
  mkHost =
    { hostname
    , username
    , repo
    , alias
    , system ? "x86_64-linux"
    , extraModules ? [ ]
    , overlays ? [ ]
    ,
    }:

      assert builtins.isString hostname || throw "hostname must be a string";
      assert builtins.isString username || throw "username must be a string";
      assert builtins.isString repo || throw "repo must be a string";
      assert builtins.isString alias || throw "alias must be a string";
      assert hostname != "" || throw "hostname cannot be empty";
      assert username != "" || throw "username cannot be empty";

      let
        identity' = identity // { inherit hostname; };
      in
      lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs repo alias; identity = identity'; };
        modules = [
          ../hosts/${hostname}
          ../users/${username}/nixos.nix

          { nixpkgs.overlays = overlays; }

          inputs.stylix.nixosModules.stylix

          ({ config, ... }: {
            assertions = [
              {
                assertion = config.networking.hostName == hostname;
                message = ''
                  [HOSTNAME MISMATCH] - BUILD BLOCKED

                  [  Expected  ]: ${hostname}
                  [ Configured ]: ${config.networking.hostName}

                  Fix flake.nix before rebuilding.
                '';
              }
              {
                # check if user directory exists
                # prevent confusing "file not found" errors
                assertion = builtins.pathExists ../users/${username};
                message = ''
                  [USER CONFIG MISSING] - BUILD BLOCKED

                  The user directory "users/${username}" does not exist.

                  If you changed the username:
                  1. Rename "users/oldname" to "users/${username}"
                  2. Rename "home/oldname" to "home/${username}" (if on existing system)
                  3. Update ownership: chown -R ${username}:users /home/${username}
                '';
              }
            ];
          })

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs repo alias; identity = identity'; };
              sharedModules = [
                ../library/display/themes/default.nix
                (../library/display/themes + "/${identity'.theme}/default.nix")
              ];
              users.${username} = import ../users/${username}/home.nix;
              backupFileExtension = "backup";
            };
          }
        ] ++ extraModules;
      };
}
