# https://github.com/0xc000022070/zen-browser-flake
# https://home-manager-options.extranix.com/?query=programs.chromium

{ lib, pkgs, config, inputs, prefs, ... }: {
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = lib.mkDefault true;

    # https://mozilla.github.io/policy-templates/
    # official mozilla policy templates for firefox-based browsers.
    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = lib.mkForce true;
      OfferToSaveLogins = false;

      # Clears cookies, cache, history on exit
      # set it to 'true' if you prefer it.
      SanitizeOnShutdown = false;

      HttpsOnlyMode = "force_enabled";
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };

    # https://home-manager-options.extranix.com/?query=programs.firefox.profiles
    profiles.default = {
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        ublock-origin
        bitwarden
        darkreader
        sponsorblock
        auto-tab-discard
        clearurls
        privacy-badger
      ];

      # https://home-manager-options.extranix.com/?query=programs.firefox.profiles.%3Cname%3E.search
      search = {
        force = true;
        default = "google";
        order = [
          "google"
          "Youtube"
          "NixOS Options"
          "Nix Packages"
          "GitHub"
          "MDN"
          "Arch Wiki"
          "Crates.io"
        ];
        engines = {
          "NixOS Options" = {
            urls = [{ template = "https://search.nixos.org/options?query={searchTerms}"; }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };
          "Nix Packages" = {
            urls = [{ template = "https://search.nixos.org/packages?query={searchTerms}"; }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "GitHub" = {
            urls = [{ template = "https://github.com/search?q={searchTerms}&type=repositories"; }];
            definedAliases = [ "@gh" ];
          };
          "MDN" = {
            urls = [{ template = "https://developer.mozilla.org/en-US/search?q={searchTerms}"; }];
            definedAliases = [ "@mdn" ];
          };
          "Arch Wiki" = {
            urls = [{ template = "https://wiki.archlinux.org/index.php?search={searchTerms}"; }];
            definedAliases = [ "@aw" ];
          };
          "Crates.io" = {
            urls = [{ template = "https://crates.io/search?q={searchTerms}"; }];
            definedAliases = [ "@crates" ];
          };
          "Youtube" = {
            urls = [{ template = "https://www.youtube.com/results?search_query={searchTerms}"; }];
            definedAliases = [ "@yt" ];
          };
          "google".metaData.alias = "@g";
        };
      };

      # https://home-manager-options.extranix.com/?query=programs.firefox.profiles.%3Cname%3E.settings
      # mirror about:config settings for privacy and UX.
      settings = {
        "browser.startup.homepage" = "https://google.com";
        "browser.search.region" = "US";
        "browser.search.isUS" = true;
        "browser.bookmarks.showMobileBookmarks" = true;
        "browser.newtabpage.enabled" = false;
        "browser.download.panel.shown" = false;
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.resistFingerprinting" = true;
        "media.peerconnection.enabled" = false; # disable WebRTC
        "webgl.disabled" = true;
        "geo.enabled" = false;
        "dom.battery.enabled" = false;

        "browser.startup.page" = 3; # open previous windows and tabs
        "browser.sessionstore.resume_from_crash" = true;

        "browser.ctrlTab.recentlyUsedOrder" = true;
        "browser.link.open_newwindow" = 3; # open links in tabs
        "browser.tabs.insertAfterCurrent" = true; # open links from apps next to active tab
        "browser.tabs.loadInBackground" = false; # switch to new tab immediately
        "browser.tabs.warnOnClose" = true;
        "browser.warnOnQuitShortcut" = true;

        "zen.view.sidebar-only" = true;
        "zen.view.vertical-tabs.show-new-tab-button" = true;
        "zen.view.vertical-tabs.new-tab-button-at-top" = true;
        "zen.view.compact.toolbar-flash-popup" = false; # briefly make toolbar popup
        "zen.glance.enabled" = true;
        "zen.glance.trigger-modifier" = "alt";
        "zen.theme.content-element-separation" = 0;
        # TODO: enable after universal border radius is added
        # "zen.theme.border-radius" = <radius>;

        # DNS over HTTPS (DoH)
        # TODO: migrate to system-wide encrypted DNS (dnscrypt-proxy2)
        "network.trr.mode" = 2; # or 3 for stricter one
        "network.trr.uri" = "https://cloudflare-dns.com/dns-query";
        # Alternative: Quad9 (non-profit, Swiss-based, malware blocking)
        # "network.trr.uri" = "https://dns.quad9.net/dns-query";

        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "browser.in-content.dark-mode" = true;
        "layout.css.prefers-color-scheme.content-override" = 0;

        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      # https://home-manager-options.extranix.com/?query=programs.firefox.profiles.%3Cname%3E.bookmarks
      # manageable bookmark lists.
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Development";
            toolbar = true;
            bookmarks = [
              {
                name = "GitHub";
                url = "https://github.com/";
              }
              {
                name = "NixOS Search";
                url = "https://search.nixos.org/";
              }
            ];
          }
        ];
      };

      # containers and spaces aren't configured because
      # declarative config conflicts with existing browser profile state
      # spacesForce/containersForce will overwrite manual customizations
      # UUIDs must match existing spaces or browser creates duplicates
      # to enable: first clear zen workspaces in about:config, then uncomment below

      # containersForce = true;
      # containers = {
      #   Personal = {
      #     color = "purple";
      #     icon = "fingerprint";
      #     id = 1;
      #   };
      #   Work = {
      #     color = "blue";
      #     icon = "briefcase";
      #     id = 2;
      #   };
      # };

      # spacesForce = true;
      # spaces = let
      #   containers = config.programs.zen-browser.profiles."default".containers;
      # in {
      #   "General" = {
      #     id = "3887c330-4e31-41d4-8f43-80f0c00681a9";
      #     position = 1000;
      #     icon = "chrome://browser/skin/zen-icons/selectable/home.svg";
      #   };
      #   "Code" = {
      #     id = "cdd10fab-4fc5-494b-9041-325e5759195b";
      #     icon = "chrome://browser/skin/zen-icons/selectable/code.svg";
      #     container = containers."Work".id;
      #     position = 2000;
      #   };
      # };

      # Zen mods configured in userChrome
      # - Smaller Compact Mode by n7itro
      # - Add more ...
      userChrome = ''
        @media (-moz-bool-pref: "zen.view.sidebar-expanded") {
          #navigator-toolbox {
            --zen-navigation-toolbar-min-width: 100px !important;
          }
        }

        @media (-moz-bool-pref: "zen.view.compact.hide-tabbar") {
          :root[zen-compact-mode="true"] #navigator-toolbox {
            top: calc((100vh - var(--theme-smaller_compact_mode-sidebar_height)*1vh)/2) !important;
            height: calc(var(--theme-smaller_compact_mode-sidebar_height) * 1vh) !important;

            @media not (-moz-bool-pref: "zen.view.compact.hide-toolbar") {
              & {
                height: calc(var(--theme-smaller_compact_mode-sidebar_height) * 1vh - var(--zen-toolbar-height-with-bookmarks)) !important;
              }
            }
          }
        }
      '';
    };
  };

  # https://home-manager-options.extranix.com/?query=programs.chromium
  # extension ids from chrome web store urls.
  programs.chromium = {
    enable = lib.mkDefault true;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
    ];
  };

  home.sessionVariables.BROWSER = lib.mkDefault prefs.browser;
}
