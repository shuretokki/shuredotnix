# validation assertions for early misconfiguration detection
# these run at nix evaluation time, before any build starts.

{ lib, config, vars, ... }:
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

  themePath = ../display/themes + "/${vars.theme}/default.nix";
in
{
  config.assertions = [
    {
      assertion = vars.username != "";
      message = "vars.username must not be empty";
    }

    {
      assertion = builtins.match "^[a-z_][a-z0-9_-]{0,31}$" vars.username != null;
      message = "vars.username '${vars.username}' is not a valid UNIX username (lowercase, start with letter/underscore, max 32 chars)";
    }

    {
      assertion = !builtins.elem vars.username reservedUsernames;
      message = "vars.username '${vars.username}' is a reserved system username. Choose a different name.";
    }

    {
      assertion = vars.theme != "";
      message = "vars.theme must be set";
    }

    {
      assertion = builtins.pathExists themePath;
      message = "Theme '${vars.theme}' does not exist. Expected path: ${toString themePath}";
    }

    {
      assertion = config.library.core.sops.keyFile != "";
      message = "library.core.sops.keyFile must be configured";
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
