# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/desktops/gnome/sushi.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/nautilus-open-any-terminal.nix

{ config, lib, pkgs, vars, ... }:
let
  cfg = config.library.core.files;
in {
  options.library.core.files = {
    enable = lib.mkEnableOption "File manager integrations";
  };

  config = lib.mkIf cfg.enable {
    # preview files by pressing Spacebar in the file manager
    services.gnome.sushi = {
      enable = true;
    };

    programs.nautilus-open-any-terminal = {
      enable = true;

      # terminal emulator to launch
      # see: https://github.com/Stunkymonkey/nautilus-open-any-terminal#supported-terminal-emulators
      terminal = vars.terminal;
    };
  };
}
