{ pkgs, repo, identity }:

pkgs.writeShellScriptBin "sdn-shell" ''
  FLAKE_PATH="/home/${identity.username}/${repo}"

  if [ ! -d "$FLAKE_PATH" ]; then
    echo "[ERROR] Flake not found at $FLAKE_PATH"
    exit 1
  fi

  SHELL_NAME="${1:-default}"

  CLEAN_NAME="${SHELL_NAME#.}"
  CLEAN_NAME="${CLEAN_NAME#*#}"

  echo "[SDN] Enter context: $CLEAN_NAME"
  exec nix develop "$FLAKE_PATH#$CLEAN_NAME" "${@:2}"
''
