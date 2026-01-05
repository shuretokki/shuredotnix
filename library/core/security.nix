# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/security/polkit.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/ssh/sshd.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/desktops/gnome/gnome-keyring.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/security/pam.nix

{ config, pkgs, vars, ... }: {
  # polkit toolkit assists unprivileged processes to speak to privileged processes.
  # essential for GUI operations like mounting drives, rebooting, or managing networks.
  security.polkit = {
    enable = true;

    # debug logs (view with: journalctl -u polkit)
    debug = false;

    # admin identities (defaults to wheel group)
    # defines who can authenticate as an administrator.
    # adminIdentities = [ "unix-group:wheel" ];
  };

  services.openssh = {
    enable = true;

    # socket-activated sshd
    # - true: systemd starts sshd only when a connection establishes (should save RAM)
    # - false: sshd runs effectively as a daemon (should lower latency)
    startWhenNeeded = true;

    # allows using tools like FileZilla, WinSCP, or sshfs
    allowSFTP = true;

    # automatically open port 22 in the firewall
    openFirewall = true;

    settings = {
      # disable password authentication to prevent brute-force attacks.
      # you MUST use SSH keys (public/private) to log in.
      PasswordAuthentication = false;

      # root login policy
      # - "yes": allow root login
      # - "no": disable root login entirely
      # - "prohibit-password": allow root login ONLY with keys
      PermitRootLogin = "prohibit-password";

      # disable challenge response authentication
      # further reduces attack surface by disabling interactive auth methods.
      KbdInteractiveAuthentication = false;

      # enable X11 Forwarding
      # allows running GUI applications remotely and displaying them locally.
      # example: ssh -X user@host "firefox"
      X11Forwarding = true;
    };
  };

  # gnome-keyring daemon manages user's security credentials (passwords, keys).
  # used by: NetworkManager (WiFi), VSCode (Sync), Chrome, etc.
  services.gnome.gnome-keyring.enable = config.library.display.hyprland.enable;

  # integrate gnome-keyring with login structure.
  # this unlocks the 'login' keyring automatically when you log in to the system.
  security.pam.services.login.enableGnomeKeyring = config.library.display.hyprland.enable;
}
