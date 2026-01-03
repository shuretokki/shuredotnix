# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/console.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/locale.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/i18n.nix

{ lib, pkgs, vars, ... }:
{
  time.timeZone = vars.timezone;

  i18n = {
    # The default locale for the system
    # Controls language, date format, numbering, etc.
    defaultLocale = vars.locale;

    # Extra locale settings to override specific aspects of the default locale
    # Useful for mixing languages (e.g. English system with German formats)
    extraLocaleSettings = {
      LC_ADDRESS = vars.locale;
      LC_IDENTIFICATION = vars.locale;
      LC_MEASUREMENT = vars.locale;
      LC_MONETARY = vars.locale;
      LC_NAME = vars.locale;
      LC_NUMERIC = vars.locale;
      LC_PAPER = vars.locale;
      LC_TELEPHONE = vars.locale;
      LC_TIME = vars.locale;
    };

    # Supported locales (deprecated in favor of extraLocales, but still useful to know)
    # supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  console = {
    enable = true;

    # Keyboard mapping for the virtual console
    # "us", "uk", "fr", "de", "dvorak", etc.
    keyMap = "us";

    # Console font
    # Use null to let kernel choose built-in font (usually 8x16 or Terminus)
    font = null;

    # Use X11 keyboard settings for the console
    # If true, keyMap is ignored and xserver.xkb settings are used
    useXkbConfig = false;

    # Enable setting console options in initrd (early boot)
    # Useful for entering encryption passwords with non-US layouts
    earlySetup = false;

    # Custom 16-color palette for the console
    # colors = [ "000000" "AA0000" ... ];
  };

  # Location services (provider, lat/long)
  # Used by night light (redshift/gammastep) and time synchronization
  location = {
    provider = "manual";
    # Sydney, Australia (Example)
    # latitude = -33.8688;
    # longitude = 151.2093;
  };
}
