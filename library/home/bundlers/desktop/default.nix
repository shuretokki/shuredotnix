{ ... }: {
  imports = [
    ./browser.nix
    ./terminal.nix
    ./editor.nix
    ./music
    ./files.nix
    ./services.nix
    ./syncthing.nix
    ./mime.nix
    ./vicinae.nix
    ./discord.nix
    ./ferdium.nix
  ];
}
