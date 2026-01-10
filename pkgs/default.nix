{ pkgs, repo, alias }: {
  # add your custom packages here...
  "${alias}-update" = pkgs.callPackage ./sys-update { inherit repo alias; };

  # example-tool = pkgs.callPackage ./example-tool { };
}
