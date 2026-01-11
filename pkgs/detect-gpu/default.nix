{ pkgs }:

pkgs.writeShellScriptBin "detect-gpu" ''
  set -euo pipefail

  usage() {
    echo "Usage: detect-gpu [hostname] [--dry-run] [--force]"
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
  require lspci
  require grep

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
  target_file="$target_dir/gpu.nix"

  if [ -f "$target_file" ] && [ $force -eq 0 ] && [ $dry_run -eq 0 ]; then
    error "$target_file exists (use --force to overwrite)"
  fi

  echo "[GPU] scanning hardware"
  gpu_list=$(lspci -mm -nn 2>/dev/null | grep -Ei "VGA|3D" || true)

  config_body="  library.core.gpu.none = true;"

  if [ -n "$gpu_list" ]; then
    has_intel=0
    has_nvidia=0
    has_amd=0
    nvidia_device=""

    while IFS= read -r line; do
      vendor=$(echo "$line" | cut -d '"' -f 4)
      device=$(echo "$line" | cut -d '"' -f 6)
      echo "[GPU] found: $vendor $device"
      case "$vendor" in
        *Intel*) has_intel=1 ;;
        *NVIDIA*) has_nvidia=1; nvidia_device="$device" ;;
        *AMD*|*ATI*) has_amd=1 ;;
      esac
    done <<< "$gpu_list"

    if [ $has_nvidia -eq 1 ]; then
      is_modern=0
      is_legacy_470=0
      is_legacy_390=0

      if echo "$nvidia_device" | grep -Ei "RTX|A[0-9]{4}|T[0-9]{3,4}" >/dev/null; then
        is_modern=1
      elif echo "$nvidia_device" | grep -Ei "GTX (9|7|6)[0-9]{2}" >/dev/null; then
        is_legacy_470=1
      elif echo "$nvidia_device" | grep -Ei "GTX (5|4)[0-9]{2}" >/dev/null; then
        is_legacy_390=1
      fi

      open_driver="false"
      [ $is_modern -eq 1 ] && open_driver="true"

      legacy_decl=""
      [ $is_legacy_470 -eq 1 ] && legacy_decl="    legacy = \"470\";"
      [ $is_legacy_390 -eq 1 ] && legacy_decl="    legacy = \"390\";"

      config_body="  library.core.gpu.nvidia = {
    enable = true;
    open = $open_driver;
$legacy_decl
  };"
      [ $has_intel -eq 1 ] && echo "[WARNING] hybrid graphics (Intel+NVIDIA)"
    elif [ $has_amd -eq 1 ]; then
      config_body="  library.core.gpu.amd.enable = true;"
    fi
  fi

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
    grep -q "./gpu.nix" "$target_dir/default.nix" 2>/dev/null || echo "[NOTE] add ./gpu.nix to imports"
  fi
''
