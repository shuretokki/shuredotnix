# https://search.nixos.org/options?query=users.users

# nixos-level user configuration.
# defines the system user account, groups, and default shell.
# companion to home.nix which handles user environment.

{ pkgs, identity, ... }: {
  users.users.${identity.username} = {
    uid = 1000; # keep consistent across reinstalls for file ownership
    isNormalUser = true;
    description = identity.username;

    # groups grant permissions without sudo:
    # - wheel: sudo access
    # - networkmanager: manage wifi/vpn
    # - input: access input devices (touchpad, tablet)
    # - video: brightness control, gpu access
    # - audio: direct audio device access (usually not needed with pipewire)
    extraGroups = [ "networkmanager" "wheel" "input" "video" "audio" ];

    # TODO: consider switching to zsh or fish and managing via home-manager.
    # bash is used here for system-level login; user shell config is in home.nix.
    shell = pkgs.bash;
  };
}
