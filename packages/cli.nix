{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        btop
        eza
        zoxide
        wget
        curl
        git
        gh
        ripgrep
        fastfetch
        fzf
        bat
        fd
        unzip
        zip
    ];
}
