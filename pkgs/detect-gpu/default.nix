# SPDX-License-Identifier: MIT
# detect-gpu: identify graphics hardware and suggest nix configuration

{ pkgs }:
pkgs.writeShellScriptBin "detect-gpu" ''
	if [ "$EUID" -ne 0 ]; then
		echo "warning: not running as root, PCI details might be truncated"
	fi

	echo "scanning for graphics hardware..."
	echo "--------------------------------"

	gpu_list=$(lspci -mm -nn | grep -Ei "VGA|3D")

	if [ -z "$gpu_list" ]; then
		echo "error: no discrete GPU detected via lspci"
		exit 1
	fi

	echo "$gpu_list" | while read -r line; do
		# lspci -mm format: slot class vendor device [subsystem-vendor subsystem-device]
		vendor=$(echo "$line" | cut -d '"' -f 4)
		device=$(echo "$line" | cut -d '"' -f 6)

		echo "found: $vendor $device"

		case "$vendor" in
		*NVIDIA*)
			# architecture check: RTX 20/30/40/50, A-series, T-series are modern
			is_modern=0
			if echo "$device" | grep -Ei "RTX (20|30|40|50|A[0-9]000|T[0-9]000)" >/dev/null; then
				is_modern=1
			fi

			echo "  logic: nvidia detected ($device)"
			echo "  suggested config:"
			echo "    library.core.gpu.nvidia = {"
			echo "      enable = true;"
			if [ $is_modern -eq 1 ]; then
				echo "      open = true;  /* detected modern turing+ architecture */"
			else
				echo "      open = false; /* detected legacy or gtx architecture */"
			fi
			echo "    };"
			;;
		*AMD*|*ATI*)
			echo "  logic: amd detected"
			echo "  suggested config:"
			echo "    library.core.gpu.amd.enable = true;"
			;;
		*Intel*)
			echo "  logic: intel igpu detected (likely integrated)"
			;;
		*)
			echo "  logic: unknown vendor ($vendor)"
			;;
		esac
		echo ""
	done

	echo "--------------------------------"
	echo "copy the relevant block to your host config (e.g. hosts/desktop/default.nix)"
''
