{ pkgs }:

pkgs.writeShellScriptBin "sys-update" ''
  echo "updating..."
  cd ~/shuredotnix || exit 1

  echo "pulling latest changes..."
  ${pkgs.git}/bin/git pull

  echo "rebuilding system..."
  ${pkgs.nh}/bin/nh os switch

  echo "[DONE!]"
''
