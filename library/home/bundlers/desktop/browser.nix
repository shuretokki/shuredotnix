# https://github.com/0xc000022070/zen-browser-flake
# https://home-manager-options.extranix.com/?query=programs.chromium
# TODO: make zen declarative (settings, extensions, mods)
# TODO: make chromium declarative (settings, extensions, theme)

{ lib, pkgs, inputs, prefs, ... }: {
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = lib.mkDefault true;

    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
  };

  programs.chromium = {
    enable = lib.mkDefault true;
    extensions = [
      # uBlock Origin
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
    ];
  };

  home.sessionVariables.BROWSER = lib.mkDefault prefs.browser;
}
