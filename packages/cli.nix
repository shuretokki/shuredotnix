{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        wget
        curl
        git
        gh
        unzip
        zip
        fastfetch
    ];
}
