# https://home-manager-options.extranix.com/?query=xdg.mimeApps

# sets default browser for URL handlers.
# mkForce overrides other modules that might set defaults.

{ lib, prefs, ... }:
let
  # zen browser's desktop file is named zen-beta.desktop, not zen.desktop
  browser = if prefs.browser == "zen" then "zen-beta" else prefs.browser;
in
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = lib.mkForce "${browser}.desktop";
      "x-scheme-handler/http" = lib.mkForce "${browser}.desktop";
      "x-scheme-handler/https" = lib.mkForce "${browser}.desktop";
      "x-scheme-handler/about" = lib.mkForce "${browser}.desktop";
      "x-scheme-handler/unknown" = lib.mkForce "${browser}.desktop";
    };
  };
}
