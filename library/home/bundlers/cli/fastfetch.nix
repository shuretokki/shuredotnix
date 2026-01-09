# https://github.com/fastfetch-cli/fastfetch
{ pkgs, ... }:
{
  home.packages = [ pkgs.fastfetch ];

  # Run fastfetch on shell start
  # optional - uncomment if desired
  # programs.zsh.initExtra = "fastfetch";
  # programs.bash.initExtra = "fastfetch";
}
