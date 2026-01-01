{ inputs }:
let
  lib = inputs.nixpkgs.lib;

  vars = if builtins.pathExists ../vars.local.nix
         then import ../vars.local.nix
         else import ../vars.nix;
in
{
  mkHost = {
    hostname,
    username,
    system ? "x86_64-linux",
    hostVars ? {},
    extraModules ? []
  }:

  assert builtins.isString hostname || throw "hostname must be a string";
  assert builtins.isString username || throw "username must be a string";
  assert hostname != "" || throw "hostname cannot be empty";
  assert username != "" || throw "username cannot be empty";

  let
    mergedVars = vars // hostVars // { inherit hostname username; };
  in
  lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; vars = mergedVars; };
    modules = [
      ../hosts/${hostname}
      ../users/${username}/nixos.nix

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
        ];
      })

      inputs.home-manager.nixosModules.home-manager {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs; vars = mergedVars; };
          sharedModules = [
            inputs.vicinae.homeManagerModules.default
            ../library/display/themes/default.nix
            (../library/display/themes + "/${mergedVars.theme}/default.nix")
          ];
          users.${username} = import ../users/${username}/home.nix;
          backupFileExtension = "backup";
        };
      }
    ] ++ extraModules;
  };
}
