# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/desktops/pipewire/pipewire.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/security/rtkit.nix

{ config, lib, pkgs, ... }:
let
  cfg = config.library.core.audio;
in {
  options.library.core.audio = {
    enable = lib.mkEnableOption "PipeWire audio stack";
  };

  config = lib.mkIf cfg.enable {
    # Disable PulseAudio in favor of PipeWire
    # PipeWire provides PulseAudio compatibility via pipewire-pulse
    services.pulseaudio.enable = false;

    # Required by PipeWire and PulseAudio for low-latency audio
    security.rtkit = {
      enable = true;
      # Optional: Customize rtkit-daemon priority settings
      # args = [ "--our-realtime-priority=29" "--max-realtime-priority=28" ];
    };

    services.pipewire = {
      enable = true;

      # Use PipeWire as the primary sound server
      # Automatically set when alsa, jack, or pulse is enabled
      audio.enable = true;

      # Start PipeWire when apps connect
      socketActivation = true;

      # ALSA support - required for most Linux applications
      alsa = {
        enable = true;
        # Enable 32-bit ALSA support on 64-bit systems
        # Required for 32-bit applications (games, wine, etc.)
        support32Bit = true;
      };

      # PulseAudio server emulation
      # Allows PulseAudio applications to work with PipeWire
      pulse.enable = true;

      # JACK audio emulation for professional audio applications
      # Enables low-latency audio for DAWs like Ardour, Bitwig, etc.
      jack.enable = false;

      # Opens UDP/6001-6002 for RAOP/AirPlay timing and control data
      raopOpenFirewall = false;

      # Additional PipeWire configuration drop-ins
      # Each item becomes a file in /etc/pipewire/*.conf.d/
      extraConfig = {
        # Main PipeWire server configuration
        # See: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-PipeWire
        pipewire = {
          # "10-clock-rate" = {
          #   "context.properties" = {
          #     "default.clock.rate" = 48000;
          #     "default.clock.allowed-rates" = [ 44100 48000 ];
          #   };
          # };
        };

        # Client library configuration (affects most applications)
        # See: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-client
        client = { };

        # JACK server/client configuration
        # See: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-JACK
        jack = { };

        # PulseAudio server emulation configuration
        # See: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-PulseAudio
        pipewire-pulse = { };
      };

      # Wireplumber session manager (enabled by default)
      wireplumber = {
        enable = true;
        # Additional wireplumber configuration packages
        # configPackages = [ ];
      };
    };
  };
}