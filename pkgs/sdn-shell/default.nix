{ pkgs, repo, identity }:

pkgs.writeShellScriptBin "sdn-shell" ''
  FLAKE_PATH="/home/${identity.username}/${repo}"

  if [ ! -d "$FLAKE_PATH" ]; then
    echo "[ERROR] Flake not found at $FLAKE_PATH"
    exit 1
  fi

  exec nix develop "$FLAKE_PATH" "$@"
''
