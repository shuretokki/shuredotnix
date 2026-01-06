# https://github.com/nix-community/home-manager/blob/master/modules/programs/eza.nix

{ lib
, ...
}:
{
  programs.eza = {
    enable = lib.mkDefault true;
    enableBashIntegration = true;

    icons = "auto";
    colors = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];

    theme = { };
  };
}
