let
  secrets = if builtins.pathExists ./secrets.nix then import ./secrets.nix else {
    gitname = "Your Name";
    email = "your.email@example.com";
  };
in
{
  username = "shure";
  hostname = "shure";
  inherit (secrets) gitname email;
  musicPlayer = "spotify";
  browser = "zen";
  terminal = "warp-terminal";
  wallpaperDir = "shure-wp";
}
