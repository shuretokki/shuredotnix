{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    unzip
    zip
    fastfetch
  ];
}
