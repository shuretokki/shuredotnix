# https://direnv.net/
# https://github.com/nix-community/nix-direnv
# https://home-manager-options.extranix.com/?query=programs.direnv

{ lib, ... }:
{
  programs.direnv = {
    enable = lib.mkDefault true;
    enableBashIntegration = true;

    # caches nix shell evaluation to avoid slow reloads
    # without it, `use nix` runs full evaluation every time
    nix-direnv.enable = true;

    silent = true;

    config = {
      global = {
        warn_timeout = "30s";
        hide_env_diff = false;
      };
      whitelist = {
        prefix = [ ];
        exact = [ ];
      };
    };

    # available in all .envrc files
    stdlib = ''
      # custom direnv stdlib
    '';
  };
}
