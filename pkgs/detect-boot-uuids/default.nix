{ pkgs }:

pkgs.writeShellScriptBin "detect-boot-uuids" ''
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
  fi
  
  echo "Scanning for EFI bootloaders..."
  echo "--------------------------------"
  
  # scan all partitions
  lsblk -o NAME,UUID,FSTYPE,MOUNTPOINT,SIZE -p | grep -i "vfat\|efi" | while read -r line; do
    part=$(echo "$line" | awk '{print $1}')
    uuid=$(echo "$line" | awk '{print $2}')
    
    if [ -z "$uuid" ]; then continue; fi
    
    # mount temp to check files
    mkdir -p /tmp/efi_check
    mount "$part" /tmp/efi_check 2>/dev/null
    
    if [ -f "/tmp/efi_check/EFI/Microsoft/Boot/bootmgfw.efi" ]; then
      echo "FOUND: Windows Boot Manager"
      echo "  Partition: $part"
      echo "  UUID:      $uuid"
      echo "  Config:"
      echo "    boot.dualBoot.windows = {"
      echo "      enable = true;"
      echo "      uuid = \"$uuid\";"
      echo "    };"
      echo ""
    fi
    
    if [ -f "/tmp/efi_check/EFI/OC/OpenCore.efi" ]; then
      echo "FOUND: MacOS (OpenCore)"
      echo "  Partition: $part"
      echo "  UUID:      $uuid"
      echo "  Config:"
      echo "    boot.dualBoot.macos = {"
      echo "      enable = true;"
      echo "      uuid = \"$uuid\";"
      echo "    };"
      echo ""
    fi
    
    umount /tmp/efi_check
  done
  rmdir /tmp/efi_check 2>/dev/null
  echo "--------------------------------"
  echo "Copy the relevant config block to your hosts file."
''
