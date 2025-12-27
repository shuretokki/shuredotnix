{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    nodejs
    python3
    nil
    nixpkgs-fmt
    direnv
    nix-direnv
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  environment.variables = {
    EDITOR = "code --wait";
    VISUAL = "code --wait";
  };

  programs.bash.shellAliases = {
  };
}