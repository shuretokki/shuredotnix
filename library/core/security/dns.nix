# https://wiki.nixos.org/wiki/Encrypted_DNS
# https://search.nixos.org/options?query=services.dnscrypt-proxy

{ pkgs, ... }:
let
  stateDir = "dnscrypt-proxy";
in
{
  services.dnscrypt-proxy = {
    enable = true;

    settings = {
      # https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
      # servers to use for resolution.
      # see all the list here https://dnscrypt.info/public-servers
      # quad9 is prioritized for its strong privacy policy and threat intelligence.
      server_names = [ "quad9-doh-ip4-nofilter-ecs-pri" "cloudflare" ];

      # listen for incoming dns queries on the local loopback interface.
      listen_addresses = [ "127.0.0.1:53" ];

      # enable dns-over-https (doh) for modern encryption.
      doh_servers = true;

      # define the source of resolver lists.
      # without this, dnscrypt-proxy cannot find any servers to use.
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        cache_file = "/var/lib/${stateDir}/public-resolvers.md";
      };

      # enforces dnssec validation.
      require_dnssec = true;

      # ensures resolvers don't log queries.
      require_nolog = true;

      # ensures resolvers don't filter results.
      require_nofilter = true;

      # disable ipv6 since it caused binding issues earlier.
      ipv6_servers = false;
      block_ipv6 = true;
    };
  };

  # give dnscrypt-proxy a persistent state directory for caching resolver lists.
  systemd.services.dnscrypt-proxy.serviceConfig.StateDirectory = stateDir;

  # force the system to use the local dnscrypt-proxy instance for all queries.
  networking.nameservers = [ "127.0.0.1" ];

  # prevent networkmanager from overwriting /etc/resolv.conf with dhcp-provided dns.
  networking.networkmanager.dns = "none";

  # disable systemd-resolved to avoid port 53 conflicts.
  services.resolved.enable = false;

  environment.systemPackages = with pkgs; [
    dnsutils # dig, nslookup, host
    whois # domain registration lookup
    traceroute # network path tracing
    mtr # combines ping + traceroute
  ];
}
