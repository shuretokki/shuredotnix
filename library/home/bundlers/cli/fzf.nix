# https://github.com/nix-community/home-manager/blob/master/modules/programs/fzf.nix

{ lib
, config
, ...
}:
let
  c = config.lib.stylix.colors.withHashtag;
in
{
  programs.fzf = {
    enable = lib.mkDefault true;
    enableBashIntegration = true;

    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--info=inline"
    ];

    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetOptions = [
      "--preview 'head -100 {}'"
    ];

    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    changeDirWidgetOptions = [
      "--preview 'eza --tree --level=2 --color=always {} | head -50'"
    ];

    historyWidgetOptions = [
      "--sort"
      "--exact"
    ];

    colors = lib.mkDefault {
      "bg" = c.base00;
      "bg+" = c.base01;
      "fg" = c.base05;
      "fg+" = c.base06;
      "hl" = c.base0D;
      "hl+" = c.base0D;
      "info" = c.base0A;
      "marker" = c.base0B;
      "prompt" = c.base0E;
      "spinner" = c.base0C;
      "pointer" = c.base0E;
      "header" = c.base0D;
    };

    tmux = {
      enableShellIntegration = false;
      shellIntegrationOptions = [ ];
    };
  };
}
