# https://github.com/nix-community/home-manager/blob/master/modules/programs/gh.nix

{ lib, ... }:
  programs.gh = {
    enable = lib.mkDefault true;
    gitCredentialHelper = {
      enable = lib.mkDefault true;
      hosts = [
        "https://github.com"
        "https://gist.github.com"
      ];
    };

    extensions = [
        # https://cli.github.com/manual/gh_extension
    ];

    hosts = [
      # Host-specific configuration written to {file}`$XDG_CONFIG_HOME/gh/hosts.yml`.
      # example."github.com".user = "<your_username>";
    ];
  }