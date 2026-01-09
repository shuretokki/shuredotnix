# https://wiki.nixos.org/wiki/Locales
# https://search.nixos.org/options?query=i18n.defaultLocale

{ lib, pkgs, vars, ... }:
{
  time.timeZone = vars.timezone;

  i18n = {
    # the default locale for the system
    # controls language, date format, numbering, etc.
    defaultLocale = vars.locale;

    # extra locale settings to override specific aspects of the default locale
    # useful for mixing languages (e.g. English system with German formats)
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

    # supported locales (deprecated in favor of extraLocales, but still useful to know)
    # supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  console = {
    enable = true;

    # keyboard mapping for the virtual console
    # "us", "uk", "fr", "de", "dvorak", etc.
    keyMap = "us";

    # console font
    # use null to let kernel choose built-in font (usually 8x16 or Terminus)
    font = null;

    # use X11 keyboard settings for the console
    # if true, keyMap is ignored and xserver.xkb settings are used
    useXkbConfig = false;

    # enable setting console options in initrd (early boot)
    # useful for entering encryption passwords with non-US layouts
    earlySetup = false;

    # custom 16-color palette for the console
    # colors = [ "000000" "AA0000" ... ];
  };

  # location services (provider, lat/long)
  # used by night light (redshift/gammastep) and time synchronization
  location = {
    provider = "manual";
    # Sydney, Australia (Example)
    # latitude = -33.8688;
    # longitude = 151.2093;
  };
}
