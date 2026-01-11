# laptop profile: extends desktop with power management.
# enables tlp by default for battery optimization.

{ config, lib, ... }: {
  imports = [
    ../desktop
  ];

  # enable tlp for battery management
  # library.core.power.tlp.enable = lib.mkDefault true;
  # TODO: implement power module first!
  # for now, just inherit desktop
}
