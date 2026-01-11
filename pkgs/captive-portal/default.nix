{ pkgs }:

pkgs.writeShellScriptBin "captive-portal" ''
  if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] must be run as root"
    exit 1
  fi

  case "$1" in
    on)
      echo "[PORTAL] disabling dnscrypt-proxy..."
      systemctl stop dnscrypt-proxy

      GATEWAY_DNS=$(nmcli dev show | grep IP4.DNS | head -n 1 | awk '{print $2}')

      if [ -z "$GATEWAY_DNS" ]; then
        echo "[WARNING] no DHCP DNS found, using 1.1.1.1"
        echo "nameserver 1.1.1.1" > /etc/resolv.conf
      else
        echo "[PORTAL] setting DNS to $GATEWAY_DNS"
        echo "nameserver $GATEWAY_DNS" > /etc/resolv.conf
      fi

      echo "[OK] captive portal mode enabled"
      ;;
    off)
      echo "[PORTAL] restoring dnscrypt-proxy..."
      echo "nameserver 127.0.0.1" > /etc/resolv.conf
      systemctl start dnscrypt-proxy
      echo "[OK] encrypted DNS restored"
      ;;
    status)
      if systemctl is-active --quiet dnscrypt-proxy; then
        echo "[STATUS] SECURE (dnscrypt-proxy running)"
      else
        echo "[STATUS] INSECURE (captive portal mode may be on)"
      fi
      grep "nameserver" /etc/resolv.conf
      ;;
    *)
      echo "Usage: captive-portal {on|off|status}"
      exit 1
      ;;
  esac
''
