{ lib, pkgs, ... }: {
  i18n.inputMethod = {
    enable = lib.mkDefault true;
    type = lib.mkDefault "fcitx5";
    fcitx5.waylandFrontend = lib.mkDefault true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-lua
    ];
  };

  environment.variables = {
    XMODIFIERS = lib.mkDefault "@im=fcitx";
  };
}
