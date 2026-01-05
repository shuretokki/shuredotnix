# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/networkmanager.nix
# networkmanager handles network configuration (WiFi, Ethernet, VPN)
# add users to 'networkmanager' group to allow managing connections

{ pkgs, ... }: {
  networking.networkmanager = {
    enable = true;

    wifi = {
      # "wpa_supplicant": traditional (default)
      # "iwd": modern Intel alternative (faster, sometimes more reliable)
      # backend = "wpa_supplicant";

      # randomize MAC during WiFi scans (privacy)
      # scanRandMacAddress = true;
    };

    # DHCP client implementation
    # "internal": uses NetworkManager's internal DHCP client (default)
    # "dhcpcd": uses external dhcpcd
    # dhcp = "internal";

    # DNS resolution method
    # "default": update /etc/resolv.conf directly
    # "systemd-resolved": use systemd-resolved (recommended for modern systems)
    # "dnsmasq": use dnsmasq for caching
    # dns = "default";

    # VPN and connection plugins
    # see: https://search.nixos.org/packages?query=networkmanager-
    # plugins = with pkgs; [
    #   networkmanager-openvpn
    #   networkmanager-openconnect
    #   networkmanager-l2tp
    # ];

    # logging verbosity: "OFF", "ERR", "WARN", "INFO", "DEBUG", "TRACE"
    # logLevel = "WARN";

    # interfaces to exclude from NetworkManager management
    # unmanaged = [ "docker0" "br-*" ];
  };


  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/firewall.nix
  networking.firewall = {
    enable = true;

    # "iptables", "nftables", "firewalld"
    # backend = "iptables";

    # open ports
    # localsend (cross-platform file sharing)
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];

    # common ports to open:
    # 22 = SSH
    # 80/443 = HTTP/HTTPS
    # 8080 = dev servers
    # 1714:1764 = KDE Connect

    # port ranges (e.g., for KDE Connect)
    # allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    # allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];

    # interfaces to trust completely (bypass firewall)
    # trustedInterfaces = [ "tailscale0" ];

    # ICMP ping settings
    # allowPing = true;
    # pingLimit = "--limit 1/minute --limit-burst 5";

    # log refused connections (view with: dmesg or journalctl -k)
    # logRefusedConnections = true;
    # logRefusedPackets = false;

    # reject vs drop
    # false = silently drop packets (default)
    # true = send ICMP "port unreachable" (faster feedback but easier to scan)
    # rejectPackets = false;
  };
}