{
  lib,
  config,
  identity,
  ...
}:
let
  # expected state version for this system configuration
  # should only be updated when intentionally upgrading NixOS state
  expectedStateVersion = "25.11";
in
{
  warnings =
    lib.optional (config.system.stateVersion != expectedStateVersion) ''
      [STATEVERSION MISMATCH] system.stateVersion != ${expectedStateVersion}
      Current: ${config.system.stateVersion}
      Expected: ${expectedStateVersion}

      This is allowed for mixed-version fleets but be aware of potential
      data migration issues (e.g. PostgreSQL) when upgrading state.
    ''
    ++ lib.optional (identity.timezone == "UTC") ''
      Using default timezone "UTC"
      Set your timezone in identity.nix: timezone = "Asia/Jakarta";
    ''
    ++ lib.optional (identity.theme == "default") ''
      Using default theme;
    '';
}
