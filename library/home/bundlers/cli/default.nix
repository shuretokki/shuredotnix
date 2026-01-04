{ ... }: {
  imports = [
    ./git.nix
    ./shell.nix
    ./starship.nix
    ./eza.nix
    ./bat.nix
    ./fzf.nix
    ./btop.nix
    ./zoxide.nix
    ./direnv.nix
    ./tools.nix
    ./fastfetch.nix
  ];
}
