{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget2
    curl
    git
    unzip
    zip
    sd
  ];
}
