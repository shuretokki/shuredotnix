# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/networkmanager.nix
# NetworkManager handles network configuration (WiFi, Ethernet, VPN)
# Add users to 'networkmanager' group to allow managing connections

{ pkgs, ... }: {
  networking.networkmanager = {
    enable = true;

    wifi = {
      # "wpa_supplicant": Traditional (default)
      # "iwd": Modern Intel alternative (faster, sometimes more reliable)
      # backend = "wpa_supplicant";

      # Randomize MAC during WiFi scans (privacy)
      # scanRandMacAddress = true;
    };

    # DHCP client implementation
    # "internal": Uses NetworkManager's internal DHCP client (default)
    # "dhcpcd": Uses external dhcpcd
    # dhcp = "internal";

    # DNS resolution method
    # "default": Update /etc/resolv.conf directly
    # "systemd-resolved": Use systemd-resolved (recommended for modern systems)
    # "dnsmasq": Use dnsmasq for caching
    # dns = "default";

    # VPN and connection plugins
    # See: https://search.nixos.org/packages?query=networkmanager-
    # plugins = with pkgs; [
    #   networkmanager-openvpn
    #   networkmanager-openconnect
    #   networkmanager-l2tp
    # ];

    # Logging verbosity: "OFF", "ERR", "WARN", "INFO", "DEBUG", "TRACE"
    # logLevel = "WARN";

    # Interfaces to exclude from NetworkManager management
    # unmanaged = [ "docker0" "br-*" ];
  };


  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/firewall.nix
  networking.firewall = {
    enable = true;

    # "iptables", "nftables", "firewalld"
    # backend = "iptables";

    # Open ports
    # LocalSend (cross-platform file sharing)
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];

    # Common ports to open:
    # 22 = SSH
    # 80/443 = HTTP/HTTPS
    # 8080 = Dev servers
    # 1714:1764 = KDE Connect

    # Port ranges (e.g., for KDE Connect)
    # allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    # allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];

    # Interfaces to trust completely (bypass firewall)
    # trustedInterfaces = [ "tailscale0" ];

    # ICMP ping settings
    # allowPing = true;
    # pingLimit = "--limit 1/minute --limit-burst 5";

    # Log refused connections (view with: dmesg or journalctl -k)
    # logRefusedConnections = true;
    # logRefusedPackets = false;

    # Reject vs Drop
    # false = silently drop packets (default)
    # true = send ICMP "port unreachable" (faster feedback but easier to scan)
    # rejectPackets = false;
  };
}