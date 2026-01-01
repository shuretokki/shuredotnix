{ lib, pkgs, config, vars, ... }: {
  home.packages = with pkgs; [
    warp-terminal
    ghostty
  ];

  programs.kitty = {
    enable = lib.mkDefault true;
    settings = {
      font_family = lib.mkForce config.theme.fonts.mono;
      font_size = lib.mkDefault config.theme.fonts.size;
      enable_audio_bell = false;
    };
  };

  programs.alacritty = {
    enable = lib.mkDefault true;
    settings = {
      font.normal.family = lib.mkForce config.theme.fonts.mono;
      font.size = lib.mkDefault config.theme.fonts.size;
    };
  };

  home.sessionVariables.TERMINAL = lib.mkDefault vars.terminal;
}

