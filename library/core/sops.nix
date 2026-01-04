# https://github.com/Mic92/sops-nix
#
# Usage:
# 1. Generate your own age key: age-keygen -o ~/.config/sops/age/keys.txt
# 2. Get your public key: age-keygen -y ~/.config/sops/age/keys.txt
# 3. Update .sops.yaml with your public key
# 4. Create secrets/secrets.yaml: sops secrets/secrets.yaml

{ inputs, config, lib, vars, ... }:

let
  username = vars.username;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = lib.mkDefault ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age = {
      keyFile = lib.mkDefault "/home/${username}/.config/sops/age/keys.txt";
      # sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      # generateKey = true;
    };

    secrets = {
      # github_token = {};
      # user_password = { neededForUsers = true; };
    };

    # templates."config.toml".content = ''
    #   password = "${config.sops.placeholder.some_secret}"
    # '';
  };
}
