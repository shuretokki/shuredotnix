{ pkgs }:

pkgs.writeShellScriptBin "captive-portal" ''
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
  fi

  case "$1" in
    on)
      echo "Enabling Captive Portal Mode (Disabling dnscrypt-proxy)..."
      systemctl stop dnscrypt-proxy
      
      # extract dns servers from current connection (dhcp provided)
      # using the first ipv4 dns found via nmcli
      GATEWAY_DNS=$(nmcli dev show | grep IP4.DNS | head -n 1 | awk '{print $2}')
      
      if [ -z "$GATEWAY_DNS" ]; then
        echo "Warning: No DHCP DNS found via nmcli. Fallback to 1.1.1.1"
        echo "nameserver 1.1.1.1" > /etc/resolv.conf
      else
        echo "Setting DNS to DHCP provider: $GATEWAY_DNS"
        echo "nameserver $GATEWAY_DNS" > /etc/resolv.conf
      fi
      
      echo "Done. You should now be able to authenticate on the captive portal."
      ;;
    off)
      echo "Disabling Captive Portal Mode (Restoring dnscrypt-proxy)..."
      echo "nameserver 127.0.0.1" > /etc/resolv.conf
      systemctl start dnscrypt-proxy
      echo "Done. Encrypted DNS restored."
      ;;
    status)
      if systemctl is-active --quiet dnscrypt-proxy; then
        echo "Status: SECURE (dnscrypt-proxy is running)"
      else
        echo "Status: INSECURE (Captive Portal Mode might be ON)"
      fi
      grep "nameserver" /etc/resolv.conf
      ;;
    *)
      echo "Usage: captive-portal {on|off|status}"
      echo "  on     - Disable encryption to login to wifi"
      echo "  off    - Restore encrypted DNS"
      echo "  status - Check current state"
      exit 1
      ;;
  esac
''
