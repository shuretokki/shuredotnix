{ lib, vars, ... }:
let
  git = if builtins.pathExists ../../../git.local.nix
        then import ../../../git.local.nix
        else { inherit (vars) gitname email; };

  isPlaceholder =
    git.gitname == "Your Name" ||
    git.email == "you@example.com" ||
    git.gitname == "" ||
    git.email == "";
in {
  programs.git = lib.mkIf (!isPlaceholder) {
    enable = true;
    lfs.enable = true;
    userName = git.gitname;
    userEmail = git.email;

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      credential.helper = "!gh auth git-credential";
    };

    aliases = {
      co = "checkout";
      st = "status";
      lg = "log --oneline --graph --decorate";
      last = "log -1 HEAD";
    };
  };

  warnings = lib.optional isPlaceholder ''
    Git identity not configured!

    Your git config uses placeholder values or is empty.
    To fix: Configure vars.nix or create git.local.nix at repo root with:
      { gitname = "Your Name"; email = "your@email.com"; }

    Git config will be SKIPPED until this is resolved.
  '';
}
