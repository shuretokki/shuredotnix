{ lib, vars, ... }:
let
  browser = if vars.browser == "zen" then "zen-beta" else vars.browser;
in {
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
