{ inputs, lib, ... }: {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = lib.mkDefault ../../secrets/secrets.yaml;
    age.keyFile = lib.mkDefault "/home/shure/.config/sops/age/keys.txt";

    # secrets.github_token = {};
  };
}
