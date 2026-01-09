# https://eza.rocks/
# https://home-manager-options.extranix.com/?query=programs.eza

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
