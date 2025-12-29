{ pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        chromium
        typora
        nautilus
        localsend
    ];
}
