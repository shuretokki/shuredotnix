# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/security/polkit.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/ssh/sshd.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/desktops/gnome/gnome-keyring.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/security/pam.nix

{ config, pkgs, vars, ... }: {
  # Polkit toolkit assists unprivileged processes to speak to privileged processes.
  # Essential for GUI operations like mounting drives, rebooting, or managing networks.
  security.polkit = {
    enable = true;

    # Debug logs (view with: journalctl -u polkit)
    debug = false;

    # Admin identities (defaults to wheel group)
    # Defines who can authenticate as an administrator.
    # adminIdentities = [ "unix-group:wheel" ];
  };

  services.openssh = {
    enable = true;

    # Socket-activated sshd
    # - true: systemd starts sshd only when a connection establishes (should save RAM)
    # - false: sshd runs effectively as a daemon (should lower latency)
    startWhenNeeded = true;

    # Allows using tools like FileZilla, WinSCP, or sshfs
    allowSFTP = true;

    # Automatically open port 22 in the firewall
    openFirewall = true;

    settings = {
      # Disable password authentication to prevent brute-force attacks.
      # You MUST use SSH keys (public/private) to log in.
      PasswordAuthentication = false;

      # Root Login Policy
      # - "yes": Allow root login
      # - "no": Disable root login entirely
      # - "prohibit-password": Allow root login ONLY with keys
      PermitRootLogin = "prohibit-password";

      # Disable Challenge Response Authentication
      # Further reduces attack surface by disabling interactive auth methods.
      KbdInteractiveAuthentication = false;

      # Enable X11 Forwarding
      # Allows running GUI applications remotely and displaying them locally.
      # Example: ssh -X user@host "firefox"
      X11Forwarding = true;
    };
  };

  # GNOME Keyring daemon manages user's security credentials (passwords, keys).
  # Used by: NetworkManager (WiFi), VSCode (Sync), Chrome, etc.
  services.gnome.gnome-keyring.enable = config.library.display.hyprland.enable;

  # Integate GNOME Keyring with login structure.
  # This unlocks the 'login' keyring automatically when you log in to the system.
  security.pam.services.login.enableGnomeKeyring = config.library.display.hyprland.enable;
}
