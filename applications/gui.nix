{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        spotify
        typora
        nautilus
        warp-terminal
        localsend
    ];
}
