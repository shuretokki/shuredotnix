{ pkgs, inputs, vars, ... }: {
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    configDir = ../ags;
    extraPackages = with pkgs; [
      inputs.ags.packages.${stdenv.hostPlatform.system}.astal3
      inputs.ags.packages.${stdenv.hostPlatform.system}.hyprland
      inputs.ags.packages.${stdenv.hostPlatform.system}.mpris
      inputs.ags.packages.${stdenv.hostPlatform.system}.network
      inputs.ags.packages.${stdenv.hostPlatform.system}.battery
      inputs.ags.packages.${stdenv.hostPlatform.system}.wireplumber
      inputs.ags.packages.${stdenv.hostPlatform.system}.tray
      gtksourceview
      webkitgtk_6
      accountsservice
    ];
  };
}
