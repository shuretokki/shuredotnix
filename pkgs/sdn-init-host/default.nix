{ pkgs, repo, alias, detect-gpu, detect-boot-uuids }:

pkgs.writeShellScriptBin "${alias}-init-host" ''
  set -euo pipefail

  usage() {
    echo "Usage: ${alias}-init-host <hostname> [--profile <name>] [--force] [--dry-run]"
    exit 1
  }

  error() {
    echo "[ERROR] $1"
    exit 1
  }

  require() {
    command -v "$1" >/dev/null 2>&1 || error "$1 not found"
  }

  require git

  REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || error "must be run inside dotnix repository"
  CURRENT_VERSION=$(nixos-version | cut -d. -f1-2 2>/dev/null || echo "25.11")

  hostname=""
  profile=""
  force=0
  dry_run=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --profile) profile="$2"; shift 2 ;;
      --force) force=1; shift ;;
      --dry-run) dry_run=1; shift ;;
      -*) usage ;;
      *) [ -z "$hostname" ] && hostname="$1" || usage; shift ;;
    esac
  done

  [ -z "$hostname" ] && error "hostname required"

  target_dir="$REPO_ROOT/hosts/$hostname"

  if [ -z "$profile" ]; then
    echo "Select profile for $hostname:"
    echo "  1) desktop"
    echo "  2) laptop"
    echo "  3) server"
    echo "  4) barebone"
    read -p "Choice [1-4]: " choice
    case "$choice" in
      1) profile="desktop" ;;
      2) profile="laptop" ;;
      3) profile="server" ;;
      4) profile="barebone" ;;
      *) error "invalid choice" ;;
    esac
  fi

  echo "[INIT] initializing $hostname ($profile)"

  if [ $dry_run -eq 0 ]; then
    mkdir -p "$target_dir"
    if [ -d "$target_dir" ] && [ $force -eq 0 ] && [ "$(ls -A "$target_dir" 2>/dev/null)" ]; then
       error "$target_dir exists and not empty (use --force)"
    fi
  else
    echo "[DRY-RUN] mkdir $target_dir"
  fi

  content="{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./gpu.nix
    ./boot.nix
    ../../library/core
    ../../library/profiles/''${profile}
  ];

  system.stateVersion = \"$CURRENT_VERSION\";
}
"
  if [ $dry_run -eq 1 ]; then
    echo "[DRY-RUN] default.nix content:"
    echo "$content"
  else
    echo "$content" > "$target_dir/default.nix"
    echo "[OK] generated default.nix"
  fi

  if [ $dry_run -eq 1 ]; then
    echo "[DRY-RUN] copy/generate hardware-configuration.nix"
  else
    current_host=$(hostname)
    if [ "$current_host" = "$hostname" ] && [ -f "/etc/nixos/hardware-configuration.nix" ]; then
      cp /etc/nixos/hardware-configuration.nix "$target_dir/"
      echo "[OK] copied local hardware-configuration.nix"
    else
      echo "{ ... }: { }" > "$target_dir/hardware-configuration.nix"
      echo "[WARNING] generated dummy hardware-configuration.nix"
      [ "$current_host" != "$hostname" ] && echo "[ACTION] running on $current_host, target is $hostname. Generate real config manually."
    fi
  fi

  detect_bin="${detect-gpu}/bin/detect-gpu"
  detect_boot="${detect-boot-uuids}/bin/detect-boot-uuids"

  args=""
  [ $dry_run -eq 1 ] && args="--dry-run"
  [ $force -eq 1 ] && args="$args --force"

  echo "[INIT] detecting hardware"
  $detect_bin $args "$hostname" || echo "[WARN] GPU detection failed or skipped"
  $detect_boot $args "$hostname" || echo "[WARN] Boot detection failed or skipped"

  if [ $dry_run -eq 0 ]; then
    echo "[OK] host initialized"
    echo "Run 'nh os switch -H $hostname' to apply"
  fi
''
