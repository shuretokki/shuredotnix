{ pkgs }: {
  # add your custom packages here...
  sys-update = pkgs.callPackage ./sys-update { };

  # example-tool = pkgs.callPackage ./example-tool { };
}
