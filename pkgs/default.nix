{ pkgs, repo, alias }:
let
  detect-gpu = pkgs.callPackage ./detect-gpu { };
  detect-boot-uuids = pkgs.callPackage ./detect-boot-uuids { };
in {
  # add your custom packages here...
  "${alias}-update" = pkgs.callPackage ./sys-update { inherit repo alias; };

  "captive-portal" = pkgs.callPackage ./captive-portal { };

  "detect-gpu" = detect-gpu;
  "detect-boot-uuids" = detect-boot-uuids;

  "menu" = pkgs.callPackage ./menu { inherit alias; };
  "sdn-shell" = pkgs.callPackage ./sdn-shell { inherit repo; identity = import ../identity.nix; };

  "${alias}-init-host" = pkgs.callPackage ./sdn-init-host {
    inherit repo alias detect-gpu detect-boot-uuids;
  };
}
