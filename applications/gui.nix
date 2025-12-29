{ pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        antigravity-nix.packages.x86_64-linux.default
        chromium
        typora
        nautilus
        localsend
    ];
}
