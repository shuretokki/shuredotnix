{
  lib,
  pkgs,
  ...
}:
{
  programs.opencode.enable = true;
  programs.opencode.settings = {
    theme = "stylix";
    plugin = [  "opencode-antigravity-auth"
                "oh-my-opencode" ];
  };
}
