# server profile: headless configuration without gui.
# used by hosts that don't need display (servers, vms, containers).
#
# explicitly disables display to prevent accidental gui activation.
# only cli bundler is imported for home-manager.

{ config, lib, pkgs, vars, ... }: {
  library.display.sddm.enable = false;
  library.display.hyprland.enable = false;

  environment.systemPackages = with pkgs; [
    wget2 curl git unzip zip sd
    nil nixfmt-rfc-style direnv
  ];

  home-manager.users.${vars.username} = {
    imports = [ ../../home/bundlers/cli ];
  };
}
