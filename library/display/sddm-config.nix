{ config, pkgs, vars, ... }:
let
  themeDir = ./themes + "/${vars.theme}";

  font = config.theme.fonts.sans or "SF Pro Rounded";
  background = config.theme.wallpaper or null;
in {
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    autoNumlock = true;
    theme = "SilentSDDM";
    extraPackages = with pkgs.kdePackages; [
      qtmultimedia
      qtsvg
      qt5compat
      qtdeclarative
      qtvirtualkeyboard
      qtwayland
      layer-shell-qt
      qtquick3d
    ];
    settings = {
      General = {
        InputMethod = "qtvirtualkeyboard";
        GreeterEnvironment = "QT_IM_MODULE=qtvirtualkeyboard${pkgs.lib.optionalString config.hardware.nvidia.modesetting.enable ",LIBVA_DRIVER_NAME=nvidia,QT_MULTIMEDIA_PREFERRED_PLUGINS=ffmpeg,GBM_BACKEND=nvidia-drm,__GLX_VENDOR_LIBRARY_NAME=nvidia"}";
      };
      Theme = {
        CursorTheme = "apple-cursor";
      };
    };
  };
}
