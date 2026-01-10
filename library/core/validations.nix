# validation assertions for early misconfiguration detection
# these run at nix evaluation time, before any build starts.

{ lib, config, identity, repo, alias, ... }:
let
  # usernames that should not be used as primary user
  reservedUsernames = [
    "root"
    "bin"
    "daemon"
    "sys"
    "nobody"
    "www-data"
    "lp"
    "games"
    "mail"
    "sync"
    "shutdown"
    "halt"
    "uucp"
    "operator"
  ];

  themePath = ../display/themes + "/${identity.theme}/default.nix";
in
{
  config.assertions = [
    {
      assertion = identity.username != "";
      message = "identity.username must not be empty";
    }

    {
      assertion = builtins.match "^[a-z_][a-z0-9_-]{0,31}$" identity.username != null;
      message = "identity.username '${identity.username}' is not a valid UNIX username (lowercase, start with letter/underscore, max 32 chars)";
    }

    {
      assertion = !builtins.elem identity.username reservedUsernames;
      message = "identity.username '${identity.username}' is a reserved system username. Choose a different name.";
    }

    {
      assertion = identity.theme != "";
      message = "identity.theme must be set";
    }

    {
      assertion = builtins.pathExists themePath;
      message = "Theme '${identity.theme}' does not exist. Expected path: ${toString themePath}";
    }

    {
      assertion = config.library.core.sops.keyFile != "";
      message = "library.core.sops.keyFile must be configured";
    }

    {
      assertion = alias == "sdn";
      message = ''
        [PROJECT IDENTITY MISMATCH]
        The project alias is set to "${alias}", but "sdn" is required.
        This protects structural aliases like sdn-update and cdsdn.

        If you ARE sure about this change:
        1. Update alias in flake.nix
        2. Update this assertion in library/core/validations.nix
      '';
    }

    {
      assertion = repo == "dotnix";
      message = ''
        [PROJECT REPO MISMATCH]
        The project repo is set to "${repo}", but "dotnix" is required.
        This protects hardcoded paths in scripts and system configs.

        If you ARE sure about this change:
        1. Update repo in flake.nix
        2. Update this assertion in library/core/validations.nix
      '';
    }
  ];

  config.systemd.services.sops-key-check = {
    description = "check sops key file exists";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      KEY_FILE="${config.library.core.sops.keyFile}"
      if [ ! -f "$KEY_FILE" ]; then
        echo "[WARNING] SOPS key file not found at $KEY_FILE"
        echo "Secrets decryption will fail. Run: age-keygen -o $KEY_FILE"
      else
        echo "[INFO   ] SOPS key file found at $KEY_FILE"
      fi
    '';
  };
}
