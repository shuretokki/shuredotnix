{ lib, vars, ... }: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = lib.mkDefault "${vars.browser}.desktop";
      "x-scheme-handler/http" = lib.mkDefault "${vars.browser}.desktop";
      "x-scheme-handler/https" = lib.mkDefault "${vars.browser}.desktop";
      "x-scheme-handler/about" = lib.mkDefault "${vars.browser}.desktop";
      "x-scheme-handler/unknown" = lib.mkDefault "${vars.browser}.desktop";
    };
  };
}
