# base hyprland settings without keybinds.
# used by library/display/hyprland.nix which adds keybinds separately.

{ config, pkgs, lib, ... }:
let
  appearance = import ./appearance.nix { inherit config lib; };
  rules = import ./rules.nix;
  input = import ./input.nix;
  env = import ./env.nix { inherit pkgs; };
  autostart = import ./autostart.nix { inherit pkgs; };
  scripts = import ./scripts.nix { inherit pkgs; };
in
{
  inherit scripts;
  settings = appearance // rules // input // env // autostart // {
    monitor = ",preferred,auto,1";
  };
}
