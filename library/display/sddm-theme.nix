{ pkgs, background ? null }:

pkgs.stdenv.mkDerivation {
  name = "silent-sddm";
  src = pkgs.fetchFromGitHub {
    owner = "uiriansan";
    repo = "SilentSDDM";
    rev = "master"; # You might want to use a specific commit hash for reproducibility
    sha256 = "1brvya8r5q03b4jhwv1dqnllaw3iw9d1fnj8ybz9r6gcd1mbf161";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/SilentSDDM
    cp -R ./* $out/share/sddm/themes/SilentSDDM
    ${pkgs.lib.optionalString (background != null) ''
      cp ${background} $out/share/sddm/themes/SilentSDDM/backgrounds/custom.jpg
      sed -i 's/background = smoky.jpg/background = custom.jpg/g' $out/share/sddm/themes/SilentSDDM/configs/default.conf
    ''}
  '';
}
