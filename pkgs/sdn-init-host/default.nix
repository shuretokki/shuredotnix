{
  pkgs,
  repo,
  alias,
  detect-gpu,
  detect-boot-uuids,
}:

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

    if [ "$EUID" -ne 0 ]; then
      error "must be run as root (sudo)"
    fi

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
    if [[ ! "$hostname" =~ ^[a-zA-Z0-9-]+$ ]]; then
      error "invalid hostname: must contain only alphanumeric characters and hyphens"
    fi

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

    set_hostname_line=""
    if [ $dry_run -eq 0 ] && [ -n "$profile" ]; then
       # Only interact if we aren't in dry-run/headless mode
       echo ""
       read -p "Set this host as the system default (sets networking.hostName)? [y/N]: " set_host_choice
       case "$set_host_choice" in
          [yY][eE][sS]|[yY])
             set_hostname_line="  networking.hostName = \"$hostname\"; # overrides identity default"
             ;;
       esac
    fi
    # Also support explicit flag if we add one later, but for now interactive is fine.

    content="{ config, pkgs, ... }: {
    imports = [
      ./hardware-configuration.nix
      ./gpu.nix
      ./boot.nix
      ../../library/core
      ../../library/profiles/''${profile}
    ];

    system.stateVersion = \"$CURRENT_VERSION\";
  $set_hostname_line
  }
  "
    if [ $dry_run -eq 1 ]; then
      echo "[DRY-RUN] default.nix content:"
      echo "$content"
    else
      echo "$content" > "$target_dir/default.nix"
      echo "[OK] generated default.nix"
    fi

    current_host=$(hostname)
    init_is_local=0
    [ "$hostname" = "$current_host" ] && init_is_local=1

    if [ $init_is_local -eq 0 ]; then
       echo "[WARN] remote init detected ($hostname != $current_host)"
       echo "[WARN] skipping ALL hardware scans (config, gpu, boot) to prevent pollution"

       echo "{ ... }: { }" > "$target_dir/hardware-configuration.nix"
       echo "{ ... }: { library.core.gpu.none = true; }" > "$target_dir/gpu.nix"
       echo "{ ... }: { }" > "$target_dir/boot.nix"

       echo "[ACTION] please populate hardware files in $target_dir manually."
    else
       if [ $dry_run -eq 1 ]; then
          echo "[DRY-RUN] generate hardware-configuration.nix from live system"
          echo "[DRY-RUN] run detect-gpu and detect-boot-uuids"
       else
          echo "[INIT] generating hardware-configuration.nix from live system..."
          if nixos-generate-config --show-hardware-config > "$target_dir/hardware-configuration.nix" 2>/dev/null; then
             echo "[OK] generated hardware-configuration.nix"
          else
             echo "{ ... }: { }" > "$target_dir/hardware-configuration.nix"
             echo "[WARN] nixos-generate-config failed, created dummy."
          fi

          detect_bin="${detect-gpu}/bin/detect-gpu"
          detect_boot="${detect-boot-uuids}/bin/detect-boot-uuids"

          echo "[INIT] detecting hardware..."
          $detect_bin $args "$hostname" || echo "[WARN] GPU detection failed"
          $detect_boot $args "$hostname" || echo "[WARN] Boot detection failed"
       fi
    fi

    if [ $dry_run -eq 0 ]; then
      echo "[OK] host initialized"
      echo "Run 'nh os switch -H $hostname' to apply"
    fi
''
