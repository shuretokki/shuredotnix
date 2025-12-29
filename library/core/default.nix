{ ... }: {
  imports = [
    ./boot.nix
    ./locale.nix
    ./audio.nix
    ./network.nix
    ./bluetooth.nix
    ./security.nix
    ./input.nix
    ./performance.nix
    ./system.nix
    ./fonts.nix
    ./sops.nix
  ];
}
