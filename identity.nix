# user identity shared across all hosts.
# edit this file to change system-wide user preferences.
# these values are imported by flake.nix and passed to utils.mkHost.

{
  username = "shure";
  locale = "en_US.UTF-8";
  timezone = "Asia/Jakarta";

  # corresponds to themes/<name>.nix in library/display/themes/
  theme = "sh";
}
