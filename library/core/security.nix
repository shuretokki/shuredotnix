{ pkgs, ... }: {
  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-lua
    ];
  };

  # System-wide environment variables
  # for Fcitx5
  environment.variables = {
    XMODIFIERS = "@im=fcitx";
  };
}
