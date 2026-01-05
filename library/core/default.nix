{ ... }: {
  imports = [
    ./locale.nix
    ./boot.nix
    ./network.nix
    ./security.nix
    ./performance.nix
    ./system.nix
    ./sops.nix
    ./audio.nix
    ./bluetooth.nix
    ./fonts.nix
    ./input.nix
    ./files.nix
    ./virtualisation.nix
  ];
}
