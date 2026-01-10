# https://wiki.nixos.org/wiki/Encrypted_DNS
# https://search.nixos.org/options?query=services.dnscrypt-proxy

{ ... }: {
  services.dnscrypt-proxy = {
    enable = true;

    settings = {
      # https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
      # servers to use for resolution.
      # see all the list here https://dnscrypt.info/public-servers
      # quad9 is prioritized for its strong privacy policy and threat intelligence.
      # using doh (dns-over-https) variants for web-standard encryption and firewall traversal.
      server_names = [ "quad9-doh-ip4" "cloudflare-doh" ];

      # listen for incoming dns queries on the local loopback interface.
      # binds to standard port 53 to act as the primary system-wide resolver.
      listen_addresses = [ "127.0.0.1:53" "[::1]:53" ];

      # enable dns-over-https (doh) for modern encryption.
      # doh is harder to block or intercept than standard dnscrypt.
      doh_servers = true;

      # enforces dnssec validation.
      # ensures records haven't been tampered with by checking cryptographic signatures.
      require_dnssec = true;

      # ensures resolvers don't filter results (e.g. for ads or malware).
      # we prefer unfiltered upstream results to handle filtering ourselves if needed.
      require_nofilter = true;

      # ensures timestamps are checked to prevent replay attacks.
      # requires an accurate system clock (check ntp status if resolution fails).
      ignore_timestamps = false;
    };
  };

  # force the system to use the local dnscrypt-proxy instance for all queries.
  networking.nameservers = [ "127.0.0.1" "::1" ];

  # prevent networkmanager from overwriting /etc/resolv.conf with dhcp-provided dns.
  # ensures privacy by ignoring isp-provided resolvers.
  networking.networkmanager.dns = "none";

  # explicitly disable systemd-resolved to avoid port 53 conflicts.
  # systemd-resolved often binds to port 53 by default, which blocks dnscrypt-proxy.
  services.resolved.enable = false;
}
