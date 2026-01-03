{ pkgs, vars, ... }: {
  security.polkit.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  services.gnome.gnome-keyring.enable = vars.features.desktop;
  security.pam.services.login.enableGnomeKeyring = vars.features.desktop;
}
