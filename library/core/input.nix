# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/i18n/input-method/default.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/i18n/input-method/fcitx5.nix

{ lib, pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;

    # "ibus", "fcitx5", "nabi", "uim", "hime", "kime"
    type = "fcitx5";

    fcitx5 = {
      # Use the Wayland input method frontend
      # Recommended for Wayland compositors (Hyprland, Gnome, KDE Wayland)
      waylandFrontend = true;

      # Fcitx5 relies on addons for specific input methods and features
      addons = with pkgs; [
        # GTK+ 2/3/4 IM module for fcitx5
        # required for GTK apps
        fcitx5-gtk

        # Lua support for fcitx5
        # required for some themes/plugins
        fcitx5-lua

        # Rime support (Chinese/General)
        # fcitx5-rime

        # Mozc (Japanese)
        # fcitx5-mozc

        # Chinese Addons (Pinyin, Table, etc.)
        # fcitx5-chinese-addons

        # Themes
        # fcitx5-nord
        # fcitx5-material-color
      ];

      # (ini)
      # settings.globalOptions = {
      #   "Hotkey/TriggerKeys" = {
      #     "0" = "Control+Space";
      #   };
      # };
    };
  };

  # Environment variables configuration
  # Note: When i18n.inputMethod.enable is true, NixOS automatically sets:
  # GTK_IM_MODULE, QT_IM_MODULE, XMODIFIERS
  # So we generally don't need to manually set them unless overriding.
  environment.variables = {
    # Force XIM to use fcitx
    # often needed for older non-GTK/Qt apps
    XMODIFIERS = "@im=fcitx";
  };
}
