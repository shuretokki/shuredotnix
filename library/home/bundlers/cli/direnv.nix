# https://github.com/nix-community/home-manager/blob/master/modules/programs/direnv.nix

{ lib
, ...
}:
{
  programs.direnv = {
    enable = lib.mkDefault true;
    enableBashIntegration = true;

    nix-direnv.enable = true;

    silent = false;

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

    stdlib = ''
      # custom direnv stdlib
    '';
  };
}
