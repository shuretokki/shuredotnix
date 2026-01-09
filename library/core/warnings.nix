{ lib, config, identity, ... }:
let
  # The expected state version for this system configuration
  # should only be updated when intentionally upgrading NixOS state
  expectedStateVersion = "25.11";
in {
  assertions = [{
    assertion = config.system.stateVersion == expectedStateVersion;
    message = ''
      [STATEVERSION ERROR] Unexpected system.stateVersion change!

      Expected: ${expectedStateVersion}
      Found:    ${config.system.stateVersion}

      stateVersion should not change after initial install.
      Changing it can cause data loss or migration issues.

      If you are intentionally upgrading:
      1. Check the NixOS release notes
      2. Update expectedStateVersion in library/core/warnings.nix
    '';
  }];

  warnings =
    lib.optional (identity.timezone == "UTC") ''
      Using default timezone "UTC"
      Set your timezone in identity.nix: timezone = "Asia/Jakarta";
    ''
    ++ lib.optional (identity.theme == "default") ''
      Using default theme;
    '';
}
