# https://wiki.nixos.org/wiki/PipeWire
# https://search.nixos.org/options?query=services.pipewire

{ config, lib, pkgs, ... }:
let
  cfg = config.library.core.audio;
in
{
  options.library.core.audio = {
    enable = lib.mkEnableOption "PipeWire audio stack";
  };

  config = lib.mkIf cfg.enable {
    # disable PulseAudio in favor of PipeWire
    # PipeWire provides PulseAudio compatibility via pipewire-pulse
    services.pulseaudio.enable = false;

    # required by PipeWire and PulseAudio for low-latency audio
    security.rtkit = {
      enable = true;
      # optional: customize rtkit-daemon priority settings
      # args = [ "--our-realtime-priority=29" "--max-realtime-priority=28" ];
    };

    services.pipewire = {
      enable = true;

      # use PipeWire as the primary sound server
      # automatically set when alsa, jack, or pulse is enabled
      audio.enable = true;

      # start PipeWire when apps connect
      socketActivation = true;

      # ALSA support - required for most Linux applications
      alsa = {
        enable = true;
        # enable 32-bit ALSA support on 64-bit systems
        # required for 32-bit applications (games, wine, etc.)
        support32Bit = true;
      };

      # pulseAudio server emulation
      # allows PulseAudio applications to work with PipeWire
      pulse.enable = true;

      # JACK audio emulation for professional audio applications
      # enables low-latency audio for DAWs like Ardour, Bitwig, etc.
      jack.enable = false;

      # opens UDP/6001-6002 for RAOP/AirPlay timing and control data
      raopOpenFirewall = false;

      # additional PipeWire configuration drop-ins
      # each item becomes a file in /etc/pipewire/*.conf.d/
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
        # see: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-JACK
        jack = { };

        # pulseAudio server emulation configuration
        # see: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-PulseAudio
        pipewire-pulse = { };
      };

      # wireplumber session manager (enabled by default)
      wireplumber = {
        enable = true;
        # additional wireplumber configuration packages
        # configPackages = [ ];
      };
    };
  };
}
