# https://wiki.nixos.org/wiki/GnuPG
# https://home-manager-options.extranix.com/?query=programs.gpg

# gpg and agent configuration.
# sets strong cipher/digest preferences and enables the gpg-agent.
# pinentry-gnome3 works with hyprland/wayland for password prompts.

{ config, lib, pkgs, ... }: {
  programs.gpg = {
    enable = true;
    settings = {
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";

      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";

      charset = "utf-8";
      with-fingerprint = true;

      # hide recipient key ids in encrypted messages
      throw-keyids = true;
      keyid-format = "0xlong";
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3600; # seconds
    maxCacheTtl = 7200; # seconds
    pinentry.package = pkgs.pinentry-gnome3;
    # enableSshSupport = true; # uncomment to use gpg keys for ssh
  };
}
