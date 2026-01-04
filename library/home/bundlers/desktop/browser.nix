{ lib, pkgs, inputs, vars, ... }: {
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

  home.sessionVariables.BROWSER = lib.mkDefault vars.browser;
}
