# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/hardware/bluetooth.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/desktops/blueman.nix

{ config, lib, pkgs, ... }:
let
  cfg = config.library.core.bluetooth;
in {
  options.library.core.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth hardware support";
  };

  config = lib.mkIf cfg.enable {
    # bluetooth hardware support via BlueZ
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;

      # hsp/hfp headset profile daemon (alternative to pulseaudio's native support)
      # provides better headset microphone support for some devices
      hsphfpd.enable = false;

      # built-in BlueZ plugins to disable
      # example: [ "sap" ] to disable SIM Access Profile
      disabledPlugins = [ ];

      # main BlueZ configuration (/etc/bluetooth/main.conf)
      # see: https://github.com/bluez/bluez/blob/master/src/main.conf
      settings = {
        General = {
          # controller operation mode: dual, bredr, le
          # dual = Classic + Low Energy (default)
          # bredr = Classic Bluetooth only
          # le = Low Energy only (for BLE devices)
          ControllerMode = "dual";

          # permanently set device name (vs. hostname)
          # Name = "";

          # enable device discovery (true/false)
          Discoverable = false;

          # discoverable timeout in seconds (0 = always discoverable)
          DiscoverableTimeout = 0;

          # always allow pairing even if not discoverable
          AlwaysPairable = false;

          # pairable timeout in seconds (0 = always pairable)
          PairableTimeout = 0;

          # enable experimental features (required for some newer devices)
          Experimental = false;
        };

        Policy = {
          # auto-connect paired devices on startup
          AutoEnable = true;
        };
      };

      # input device configuration (/etc/bluetooth/input.conf)
      # for HID devices like keyboards, mice, gamepads
      # see: https://github.com/bluez/bluez/blob/master/profiles/input/input.conf
      input = {
        General = {
          # idle timeout in minutes for input devices (0 = no timeout)
          # IdleTimeout = 0;

          # only allow bonded (paired) devices for classic Bluetooth
          ClassicBondedOnly = true;
        };
      };

      # network configuration (/etc/bluetooth/network.conf)
      # For PAN (Personal Area Network) / tethering
      # see: https://github.com/bluez/bluez/blob/master/profiles/network/network.conf
      network = {
        General = {
          # disable security for network connections (not recommended)
          DisableSecurity = false;
        };
      };
    };

    # provides a system tray applet and GUI for managing Bluetooth devices
    services.blueman.enable = true;
  };
}