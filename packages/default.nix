{ lib, ... }: {
  imports = 
    let
      files = builtins.readDir ./.;
      nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix") files;
    in
    map (name: ./. + "/${name}") (lib.attrNames nixFiles);
}
