{ pkgs, ... }: {
    boot.loader.systemd-boot.enable = false;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        theme = pkgs.stdenv.mkDerivation {
            pname = "wuthering-grub-theme";
            version = "1.0";
            src = pkgs.fetchFromGitHub {
                owner = "vinceliuice";
                repo = "Wuthering-grub2-themes";
                rev = "ed3f8bcd292e7a0684f3c30f20939710d263a321";
                sha256 = "sha256-q9TLZTZI/giwKu8sCTluxvkBG5tyan7nFOqn4iGLnkA=";
            };
            installPhase = ''
                mkdir -p $out
                cp -a $src/common/*.pf2 $out/
                cp -a $src/config/theme-1080p.txt $out/theme.txt
                cp -a $src/backgrounds/background-jinxi.jpg $out/background.jpg
                cp -a $src/assets/assets-icons/icons-1080p $out/icons
                cp -a $src/assets/assets-other/other-1080p/*.png $out/
            '';
        };
    };

    # boot.loader.systemd-boot.configurationLimit = 10;

    time.timeZone = "Asia/Jakarta";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    };
}