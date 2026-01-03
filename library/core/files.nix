# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/desktops/gnome/sushi.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/nautilus-open-any-terminal.nix

{ pkgs, vars, ... }:
{
  # Preview files by pressing Spacebar in the file manager
  services.gnome.sushi = {
    enable = true;
  };

  programs.nautilus-open-any-terminal = {
    enable = true;

    # Terminal emulator to launch
    # See: https://github.com/Stunkymonkey/nautilus-open-any-terminal#supported-terminal-emulators
    terminal = vars.terminal;
  };
}
