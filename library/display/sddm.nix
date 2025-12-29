{ pkgs, background ? null }:

pkgs.stdenv.mkDerivation {
  name = "silent-sddm";
  src = pkgs.fetchFromGitHub {
    owner = "uiriansan";
    repo = "SilentSDDM";
    rev = "master";
    sha256 = "1brvya8r5q03b4jhwv1dqnllaw3iw9d1fnj8ybz9r6gcd1mbf161";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/SilentSDDM
    cp -R ./* $out/share/sddm/themes/SilentSDDM

    find $out/share/sddm/themes/SilentSDDM -type f -name "*.qml" -exec sed -i 's/RedHatDisplay/SF Pro Rounded/g' {} +
    find $out/share/sddm/themes/SilentSDDM -type f -name "*.conf" -exec sed -i 's/RedHatDisplay/SF Pro Rounded/g' {} +

    # Ensure the theme uses the correct config file if specified
    # substituteInPlace $out/share/sddm/themes/SilentSDDM/metadata.desktop \
    #   --replace "configs/default.conf" "configs/default.conf"

    ${pkgs.lib.optionalString (background != null) ''
      if [ -f "${toString background}" ]; then
        cp "${toString background}" $out/share/sddm/themes/SilentSDDM/backgrounds/custom.jpg
        sed -i 's/background = smoky.jpg/background = custom.jpg/g' $out/share/sddm/themes/SilentSDDM/configs/default.conf
      fi
    ''}
  '';
}
