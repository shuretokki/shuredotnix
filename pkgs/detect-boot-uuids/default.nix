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
  require mktemp

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

  if [ $dry_run -eq 0 ] && [ ! -d "$target_dir" ]; then
    error "target directory $target_dir does not exist. Initialize host first."
  fi

  target_file="$target_dir/boot.nix"

  if [ -f "$target_file" ] && [ $force -eq 0 ] && [ $dry_run -eq 0 ]; then
    error "$target_file exists (use --force to overwrite)"
  fi

  echo "[BOOT] scanning partitions"

  windows_uuid=""
  macos_uuid=""

  WORK_DIR=$(mktemp -d)
  trap 'rmdir "$WORK_DIR" 2>/dev/null || true' EXIT

  EFI_GUID="c12a7328-f81f-11d2-ba4b-00a0c93ec93b"

  while read -r line; do
    eval "$line"

    is_efi=0
    [[ "''${PARTTYPE,,}" == "$EFI_GUID" ]] && is_efi=1
    [[ "$MOUNTPOINT" == "/boot" || "$MOUNTPOINT" == "/boot/efi" ]] && is_efi=1

    [ $is_efi -eq 1 ] || continue
    [ -n "$UUID" ] || continue

    PART="/dev/$NAME"
    SEARCH_DIR=""
    MOUNTED_TMP=0

    if [ -n "$MOUNTPOINT" ] && [ -d "$MOUNTPOINT" ]; then
       SEARCH_DIR="$MOUNTPOINT"
    elif [ "$EUID" -eq 0 ]; then
       if mount "$PART" "$WORK_DIR" 2>/dev/null; then
          SEARCH_DIR="$WORK_DIR"
          MOUNTED_TMP=1
       fi
    fi

    if [ -n "$SEARCH_DIR" ]; then
       [ -f "$SEARCH_DIR/EFI/Microsoft/Boot/bootmgfw.efi" ] && {
          echo "[BOOT] found Windows: $UUID ($PART)"
          windows_uuid="$UUID"
       }
       [ -f "$SEARCH_DIR/EFI/OC/OpenCore.efi" ] && {
          echo "[BOOT] found macOS: $UUID ($PART)"
          macos_uuid="$UUID"
       }

       [ $MOUNTED_TMP -eq 1 ] && umount "$WORK_DIR"
    fi

    NAME="" UUID="" FSTYPE="" MOUNTPOINT="" PARTTYPE=""

  done < <(lsblk -P -o NAME,UUID,FSTYPE,MOUNTPOINT,PARTTYPE)

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
  fi
''
