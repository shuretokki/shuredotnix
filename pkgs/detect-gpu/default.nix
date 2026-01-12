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

  if [ $dry_run -eq 0 ] && [ ! -d "$target_dir" ]; then
    error "target directory $target_dir does not exist. Initialize host first."
  fi

  target_file="$target_dir/gpu.nix"

  if [ -f "$target_file" ] && [ $force -eq 0 ] && [ $dry_run -eq 0 ]; then
    error "$target_file exists (use --force to overwrite)"
  fi

  echo "[GPU] scanning hardware"
  gpu_list=$(lspci -vmm || true)

  is_laptop=0
  if [ -f /sys/class/dmi/id/chassis_type ]; then
    case "$(cat /sys/class/dmi/id/chassis_type)" in
      8|9|10|11|14|30|31|32) is_laptop=1 ;;
    esac
  fi

  has_intel=0
  has_nvidia=0
  has_amd=0
  amd_legacy=0

  # track the "oldest" architecture for driver compatibility
  # or simply the presence of specific generations.
  # 0: None, 1: Fermi, 2: Kepler/Maxwell, 3: Pascal, 4: Turing, 5: Ampere+
  nvidia_priority=99
  nvidia_bus_id=""
  intel_bus_id=""
  amd_bus_id=""

  current_slot=""
  current_vendor=""
  current_device=""
  current_class=""

  to_decimal_bus() {
    local hex_id="$1"
    local domain="0"
    local bus=""
    local slot=""
    local func=""

    if [[ "$hex_id" =~ ^([0-9a-fA-F]+):([0-9a-fA-F]+):([0-9a-fA-F]+)\.([0-9a-fA-F]+)$ ]]; then
       domain="''${BASH_REMATCH[1]}"
       bus="''${BASH_REMATCH[2]}"
       slot="''${BASH_REMATCH[3]}"
       func="''${BASH_REMATCH[4]}"
    elif [[ "$hex_id" =~ ^([0-9a-fA-F]+):([0-9a-fA-F]+)\.([0-9a-fA-F]+)$ ]]; then
       bus="''${BASH_REMATCH[1]}"
       slot="''${BASH_REMATCH[2]}"
       func="''${BASH_REMATCH[3]}"
    fi

    echo "PCI:$((16#$bus)):$((16#$slot)):$((16#$func))"
  }

  while IFS= read -r line; do
    [ -z "$line" ] && {
      if [ -n "$current_vendor" ]; then
        if echo "$current_class" | grep -Ei "VGA|3D" >/dev/null; then
          case "$current_vendor" in
            *Intel*)
              has_intel=1
              intel_bus_id="$current_slot"
              ;;
            *NVIDIA*)
              has_nvidia=1
              nvidia_bus_id="$current_slot"

              if echo "$current_device" | grep -Ei "RTX [345]|RTX A|RTX [0-9]{4}|Titan RTX|A[0-9]{3,}|T[0-9]{3,}|Quadro (RTX|T|A)" >/dev/null; then
                 # Ampere and newer
                 [ $nvidia_priority -gt 5 ] && nvidia_priority=5
              elif echo "$current_device" | grep -Ei "RTX 20|GTX 16|Quadro RTX" >/dev/null; then
                 # Turing
                 [ $nvidia_priority -gt 4 ] && nvidia_priority=4
              elif echo "$current_device" | grep -Ei "GTX 10[0-9]{2}|Titan X" >/dev/null; then
                 # Pascal
                 [ $nvidia_priority -gt 3 ] && nvidia_priority=3
              elif echo "$current_device" | grep -Ei "GTX [97][0-9]{2}|Quadro [KM]" >/dev/null; then
                 # Maxwell / Kepler
                 [ $nvidia_priority -gt 2 ] && nvidia_priority=2
              elif echo "$current_device" | grep -Ei "GTX [54][0-9]{2}" >/dev/null; then
                 # Fermi
                 [ $nvidia_priority -gt 1 ] && nvidia_priority=1
              fi
              ;;
            *AMD*|*ATI*|*Advanced\ Micro*)
              has_amd=1
              amd_bus_id="$current_slot"
              if echo "$current_device" | grep -Ei "HD 7[0-9]{3}|HD 8[0-9]{3}" >/dev/null; then
                 amd_legacy=1
              fi
              ;;
          esac
        fi
      fi
      current_slot=""
      current_vendor=""
      current_device=""
      current_class=""
      continue
    }

    key=$(echo "$line" | cut -d: -f1 | xargs)
    val=$(echo "$line" | cut -d: -f2- | xargs)

    case "$key" in
      Slot) current_slot="$val" ;;
      Vendor) current_vendor="$val" ;;
      Device) current_device="$val" ;;
      Class) current_class="$val" ;;
    esac
  done <<< "$gpu_list"

  config_body="  library.core.gpu.none = true;"

  if [ $has_nvidia -eq 1 ]; then
    open_driver="false"
    legacy_ver="null"

    case "$nvidia_priority" in
      5) open_driver="true" ;; # Ampere+
      4)
        # Turing: Default true, but false on laptops to avoid RTD3 bug
        if [ $is_laptop -eq 1 ]; then
           open_driver="false"
           echo "[GPU] Turing laptop detected, disabling open kernel modules for power efficiency"
        else
           open_driver="true"
        fi
        ;;
      3) open_driver="false" ;; # Pascal
      2) legacy_ver="\"470\""; open_driver="false" ;; # Kepler/Maxwell
      1) legacy_ver="\"390\""; open_driver="false" ;; # Fermi
      *) echo "[WARNING] Unknown NVIDIA architecture, defaulting to proprietary modern" ;;
    esac

    prime_config=""
    if [ $has_intel -eq 1 ] || [ $has_amd -eq 1 ]; then
      echo "[GPU] detected hybrid configuration, enabling prime"
      n_bus=$(to_decimal_bus "$nvidia_bus_id")
      i_bus=""
      [ $has_intel -eq 1 ] && i_bus=$(to_decimal_bus "$intel_bus_id")
      [ $has_amd -eq 1 ] && i_bus=$(to_decimal_bus "$amd_bus_id")

      prime_config="
    prime = {
      enable = true;
      mode = \"offload\";
      nvidiaBusId = \"$n_bus\";
      $( [ $has_intel -eq 1 ] && echo "intelBusId = \"$i_bus\";" || echo "amdBusId = \"$i_bus\";" )
    };"
    fi

    config_body="  library.core.gpu.nvidia = {
    enable = true;
    open = $open_driver;
    legacy = $legacy_ver;$prime_config
  };"
  elif [ $has_amd -eq 1 ]; then
    legacy_opt=""
    [ $amd_legacy -eq 1 ] && legacy_opt="
    # HD 7000/8000 series GCN 1.0/2.0
    # hardware.amdgpu.legacySupport.enable = true;"

    config_body="  library.core.gpu.amd = {
    enable = true;$legacy_opt
  };"
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
  fi
''
