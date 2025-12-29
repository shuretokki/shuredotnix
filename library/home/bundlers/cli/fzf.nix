{ lib, ... }: {
  programs.fzf = {
    enable = lib.mkDefault true;
    enableBashIntegration = lib.mkDefault true;
    defaultOptions = [ "--height 40%" "--layout=reverse" "--border" ];
    colors = {
      fg = "#ebdbb2";
      bg = "#282828";
      hl = "#fabd2f";
      "fg+" = "#ebdbb2";
      "bg+" = "#3c3836";
      "hl+" = "#fabd2f";
      info = "#8ec07c";
      prompt = "#fb4934";
      pointer = "#fb4934";
      marker = "#b8bb26";
    };
  };
}
