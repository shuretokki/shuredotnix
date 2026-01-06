# https://github.com/nix-community/home-manager/blob/master/modules/programs/alacritty.nix
# https://github.com/nix-community/home-manager/blob/master/modules/programs/ghostty.nix

{ lib
, pkgs
, config
, vars
, ...
}:
let
  c = config.lib.stylix.colors;
in
{
  home.packages = with pkgs; [
    warp-terminal
  ];

  programs.alacritty = {
    enable = lib.mkDefault true;

    settings = {
      general = {
        live_config_reload = true;
      };

      window = lib.mkDefault {
        padding = {
          x = 10;
          y = 10;
        };
        decorations = "full";
        opacity = 0.95;
        dynamic_title = true;
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        normal.family = config.theme.fonts.mono;
        bold.style = "Bold";
        italic.style = "Italic";
        size = config.theme.fonts.size;
      };

      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };
        blink_interval = 750;
        unfocused_hollow = true;
      };

      mouse = {
        hide_when_typing = true;
      };

      selection = {
        save_to_clipboard = true;
      };

      keyboard = {
        bindings = [
          { key = "V"; mods = "Control|Shift"; action = "Paste"; }
          { key = "C"; mods = "Control|Shift"; action = "Copy"; }
        ];
      };
    };
  };

  programs.ghostty = {
    enable = lib.mkDefault true;
    enableBashIntegration = true;

    clearDefaultKeybinds = false;
    installVimSyntax = false;
    installBatSyntax = true;

    systemd.enable = true;

    settings = {
      theme = "stylix";
      font-family = config.theme.fonts.mono;
      font-size = config.theme.fonts.size;

      window-padding-x = 10;
      window-padding-y = 10;
      window-decoration = true;

      background-opacity = 0.95;
      unfocused-split-opacity = 0.9;

      cursor-style = "block";
      cursor-style-blink = true;

      mouse-hide-while-typing = true;

      copy-on-select = "clipboard";
      confirm-close-surface = false;

      scrollback-limit = 10000;
    };

    themes = {
      sync = {
        background = c.base00;
        foreground = c.base05;
        cursor-color = c.base05;
        selection-background = c.base02;
        selection-foreground = c.base05;
        palette = [
          "0=${c.base00}"
          "1=${c.base08}"
          "2=${c.base0B}"
          "3=${c.base0A}"
          "4=${c.base0D}"
          "5=${c.base0E}"
          "6=${c.base0C}"
          "7=${c.base05}"
          "8=${c.base03}"
          "9=${c.base08}"
          "10=${c.base0B}"
          "11=${c.base0A}"
          "12=${c.base0D}"
          "13=${c.base0E}"
          "14=${c.base0C}"
          "15=${c.base07}"
        ];
      };
    };
  };

  xdg.configFile."warp-terminal/themes/sync.yaml".text = ''
    name: Sync
    accent: "#${c.base0D}"
    background: "#${c.base00}"
    foreground: "#${c.base05}"
    details: darker
    terminal_colors:
      normal:
        black: "#${c.base00}"
        red: "#${c.base08}"
        green: "#${c.base0B}"
        yellow: "#${c.base0A}"
        blue: "#${c.base0D}"
        magenta: "#${c.base0E}"
        cyan: "#${c.base0C}"
        white: "#${c.base05}"
      bright:
        black: "#${c.base03}"
        red: "#${c.base08}"
        green: "#${c.base0B}"
        yellow: "#${c.base0A}"
        blue: "#${c.base0D}"
        magenta: "#${c.base0E}"
        cyan: "#${c.base0C}"
        white: "#${c.base07}"
  '';

  home.sessionVariables.TERMINAL = lib.mkDefault vars.terminal;
}
