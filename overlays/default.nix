{ inputs, ... }: {
  # this one brings our custom packages from the 'pkgs' directory
  additions = final: prev: import ../pkgs { pkgs = final; };

  # this one contains whatever you want to overlay
  # you can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example: firefox = prev.firefox.override { ... };
  };
}
