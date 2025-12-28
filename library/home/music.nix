{ inputs, pkgs, vars, ... }: {
  imports = [
    (if vars.musicPlayer == "spotify" then ./spicetify.nix else { })
  ];

  home.packages = with pkgs; 
    (if vars.musicPlayer == "apple-music" then [ apple-music ] else []) ++
    (if vars.musicPlayer == "amberol" then [ amberol ] else []);
}
