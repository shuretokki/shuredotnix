# aggregates all hyprland settings into a single attrset.
# imported by library/display/hyprland.nix and merged with keybinds.

{ config, pkgs, lib, vars, ... }:
let
  appearance = import ./appearance.nix { inherit config lib; };
  rules = import ./rules.nix;
  input = import ./input.nix;
  env = import ./env.nix { inherit pkgs; };
  autostart = import ./autostart.nix { inherit pkgs; };
  keybinds = import ./keybinds.nix { inherit pkgs vars; };
  mkeybinds = import ./mkeybinds.nix { inherit pkgs; };
  scripts = import ./scripts.nix { inherit pkgs; };
in
{
  inherit scripts;
  settings = appearance // rules // input // env // autostart // {
    monitor = ",preferred,auto,1";
    bind = keybinds;
    bindm = mkeybinds;
  };
}
