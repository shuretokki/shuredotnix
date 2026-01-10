{ pkgs, repo, alias }:
  pkgs.writeShellScriptBin "${alias}-update" ''
    echo "updating..."
    cd ~/${repo} || exit 1

    echo "pulling latest changes..."
    ${pkgs.git}/bin/git pull

    echo "rebuilding system..."
    ${pkgs.nh}/bin/nh os switch

    echo "[DONE!]"
  ''
