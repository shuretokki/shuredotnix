# https://nix-community.github.io/home-manager/
# https://home-manager-options.extranix.com/?query=_module

# base home-manager config imported by all users.
# defines the _prefs option and merges user preferences with defaults.
# bundlers read from `prefs` (merged result) to configure apps.

{ lib, config, ... }:
let
  defaultPrefs = {
    gitname = "";
    email = "";
    browser = "firefox";
    terminal = "alacritty";
    editor = "nano";
    fileManager = "nautilus";
    musicPlayer = "";
  };
in
{
  # user sets _prefs in users/<name>/home.nix.
  # values are merged with defaults below, user wins on conflict.
  # bundlers access the merged result via `prefs` argument.
  options._prefs = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };

  config = {
    # merge user prefs with defaults, user wins on conflict
    _module.args.prefs = defaultPrefs // config._prefs;

    xdg.enable = lib.mkDefault true;
    news.display = "silent";

    assertions = [
      {
        assertion = config.home.stateVersion == "25.11";
        message = "home.stateVersion changed unexpectedly!";
      }
    ];

    # warn if user forgot to set _prefs
    warnings = lib.optionals (config._prefs == { }) [
      "[WARNING] Using default prefs. Set _prefs in users/*/home.nix"
    ];
  };
}
