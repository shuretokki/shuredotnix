{ pkgs, alias }:

pkgs.writeShellScriptBin "menu" ''
  echo -e "\n\033[1;34m[SDN] Available commands:\033[0m"
  echo -e "  \033[1;32mmenu\033[0m           - Show this help"
  echo -e "  \033[1;32m${alias}-update\033[0m     - Run system update pipeline"
  echo -e "  \033[1;32m${alias}-init-host\033[0m  - Scaffold a new host/device"
  echo -e "  \033[1;32mdetect-gpu\033[0m     - Scan hardware for GPU profiles"
  echo -e "  \033[1;32mdetect-boot-uuids\033[0m - Scan for dual-boot UEFI UUIDs"
  echo -e "\n\033[1;34m[Maintenance]\033[0m"
  echo -e "  \033[1;32mstatix check\033[0m   - Lint the repository"
  echo -e "  \033[1;32mnixfmt .\033[0m       - Format all nix files"
''
