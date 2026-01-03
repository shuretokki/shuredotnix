# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/hardware/bluetooth.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/desktops/blueman.nix

{ pkgs, ... }:
{
  # Bluetooth hardware support via BlueZ
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    # HSP/HFP headset profile daemon (alternative to pulseaudio's native support)
    # Provides better headset microphone support for some devices
    hsphfpd.enable = false;

    # Built-in BlueZ plugins to disable
    # Example: [ "sap" ] to disable SIM Access Profile
    disabledPlugins = [ ];

    # Main BlueZ configuration (/etc/bluetooth/main.conf)
    # See: https://github.com/bluez/bluez/blob/master/src/main.conf
    settings = {
      General = {
        # Controller operation mode: dual, bredr, le
        # dual = Classic + Low Energy (default)
        # bredr = Classic Bluetooth only
        # le = Low Energy only (for BLE devices)
        ControllerMode = "dual";

        # Permanently set device name (vs. hostname)
        # Name = "";

        # Enable device discovery (true/false)
        Discoverable = false;

        # Discoverable timeout in seconds (0 = always discoverable)
        DiscoverableTimeout = 0;

        # Always allow pairing even if not discoverable
        AlwaysPairable = false;

        # Pairable timeout in seconds (0 = always pairable)
        PairableTimeout = 0;

        # Enable experimental features (required for some newer devices)
        Experimental = false;
      };

      Policy = {
        # Auto-connect paired devices on startup
        AutoEnable = true;
      };
    };

    # Input device configuration (/etc/bluetooth/input.conf)
    # For HID devices like keyboards, mice, gamepads
    # See: https://github.com/bluez/bluez/blob/master/profiles/input/input.conf
    input = {
      General = {
        # Idle timeout in minutes for input devices (0 = no timeout)
        # IdleTimeout = 0;

        # Only allow bonded (paired) devices for classic Bluetooth
        ClassicBondedOnly = true;
      };
    };

    # Network configuration (/etc/bluetooth/network.conf)
    # For PAN (Personal Area Network) / tethering
    # See: https://github.com/bluez/bluez/blob/master/profiles/network/network.conf
    network = {
      General = {
        # Disable security for network connections (not recommended)
        DisableSecurity = false;
      };
    };
  };

  # Blueman - GTK+ Bluetooth manager
  # Provides a system tray applet and GUI for managing Bluetooth devices
  services.blueman.enable = true;
}