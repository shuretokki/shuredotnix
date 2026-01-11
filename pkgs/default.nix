{ pkgs, repo, alias }: {
  # add your custom packages here...
  "${alias}-update" = pkgs.callPackage ./sys-update { inherit repo alias; };

  "captive-portal" = pkgs.callPackage ./captive-portal { };
  "detect-boot-uuids" = pkgs.callPackage ./detect-boot-uuids { };
  "detect-gpu" = pkgs.callPackage ./detect-gpu { };
}
