{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    nodejs
    python3
    nil
    nixfmt-rfc-style
    direnv
  ];
}
