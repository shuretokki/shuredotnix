{ pkgs }:

pkgs.writeShellScriptBin "detect-boot-uuids" ''
  set -euo pipefail

  usage() {
    echo "Usage: detect-boot-uuids [hostname] [--dry-run] [--force]"
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
  require lsblk
  require grep
  require mount
  require umount

  if [ "$EUID" -ne 0 ]; then
    echo "[WARNING] not running as root, detection may miss partitions"
  fi

  dry_run=0
  force=0
  target_host=""

  for arg in "$@"; do
    case "$arg" in
      --dry-run) dry_run=1 ;;
      --force) force=1 ;;
      --help|-h) usage ;;
      -*) usage ;;
      *) target_host="$arg" ;;
    esac
  done

  repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || error "must be run inside dotnix repository"
  [ -n "$target_host" ] || target_host=$(hostname)
  target_dir="$repo_root/hosts/$target_host"
  [ -d "$target_dir" ] || target_dir="$repo_root/hosts/desktop"
  target_file="$target_dir/boot.nix"

  if [ -f "$target_file" ] && [ $force -eq 0 ] && [ $dry_run -eq 0 ]; then
    error "$target_file exists (use --force to overwrite)"
  fi

  echo "[BOOT] scanning EFI partitions"

  windows_uuid=""
  macos_uuid=""

  while read -r line; do
    eval "$line"
    # lsblk -P outputs: NAME="value" UUID="value" ... which eval sets as shell vars
    # must reset vars first to be safe, or just rely on overwrite.
    # the read loop variable 'line' contains the whole assignment string.
    # eval "$line" sets key="value" variables in current scope.

    # filter candidates:
    # 1. FSTYPE is vfat (case insensitive check often needed, but lsblk usually lowercase)
    # 2. MOUNTPOINT is /boot or /boot/efi
    is_candidate=0
    case "$FSTYPE" in
      *vfat*|*VFAT*) is_candidate=1 ;;
    esac
    case "$MOUNTPOINT" in
      /boot|/boot/efi) is_candidate=1 ;;
    esac

    # skip if not candidate or if UUID missing
    [ $is_candidate -eq 1 ] || continue
    [ -n "$UUID" ] || continue

    PART="/dev/$NAME"
    SEARCH_DIR=""
    MOUNTED_TMP=0

    # check if we can search existing mount
    if [ -n "$MOUNTPOINT" ] && [ -d "$MOUNTPOINT" ]; then
       SEARCH_DIR="$MOUNTPOINT"
    else
       # try to mount
       mkdir -p /tmp/efi_check
       if mount "$PART" /tmp/efi_check 2>/dev/null; then
          SEARCH_DIR="/tmp/efi_check"
          MOUNTED_TMP=1
       fi
    fi

    if [ -n "$SEARCH_DIR" ]; then
       # check for bootloaders
       [ -f "$SEARCH_DIR/EFI/Microsoft/Boot/bootmgfw.efi" ] && {
          echo "[BOOT] found Windows: $UUID ($PART)"
          windows_uuid="$UUID"
       }
       [ -f "$SEARCH_DIR/EFI/OC/OpenCore.efi" ] && {
          echo "[BOOT] found macOS: $UUID ($PART)"
          macos_uuid="$UUID"
       }

       # cleanup
       [ $MOUNTED_TMP -eq 1 ] && umount /tmp/efi_check
    fi

    # clear vars for next iter
    NAME="" UUID="" FSTYPE="" MOUNTPOINT=""

  done < <(lsblk -P -o NAME,UUID,FSTYPE,MOUNTPOINT)

  rmdir /tmp/efi_check 2>/dev/null || true

  config_body=""
  [ -n "$windows_uuid" ] && config_body="$config_body
  boot.dualBoot.windows = { enable = true; uuid = \"$windows_uuid\"; };"
  [ -n "$macos_uuid" ] && config_body="$config_body
  boot.dualBoot.macos = { enable = true; uuid = \"$macos_uuid\"; };"

  content="{ ... }: {
$config_body
}
"

  if [ $dry_run -eq 1 ]; then
    echo "[DRY-RUN] target: $target_file"
    echo "$content"
  else
    echo "$content" > "$target_file"
    echo "[OK] wrote $target_file"
    # shellcheck disable=SC2015
    grep -q "./boot.nix" "$target_dir/default.nix" 2>/dev/null || echo "[NOTE] add ./boot.nix to imports"
  fi
''
