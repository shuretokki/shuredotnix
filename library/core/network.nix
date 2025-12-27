{ pkgs, ... }: {
  networking.networkmanager.enable = true;

  # firewall settings for LocalSend
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];
}