# https://github.com/nix-community/home-manager/blob/master/modules/programs/gh.nix

{ lib, ... }: {
  programs.gh = {
    enable = lib.mkDefault true;
    extensions = [
      # https://cli.github.com/manual/gh_extension
    ];

    hosts = [
      # Host-specific configuration written to {file}`$XDG_CONFIG_HOME/gh/hosts.yml`.
      # example."github.com".user = "<your_username>";
    ];
  };
}
