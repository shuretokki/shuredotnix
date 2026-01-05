# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/hardware/video/nvidia.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/hardware/graphics.nix

{ config, lib, pkgs, ... }:
let
  cfg = config.library.core.gpu.nvidia;
in
{
  options.library.core.gpu.nvidia = {
    enable = lib.mkEnableOption "NVIDIA GPU support";
  };

  config = lib.mkIf cfg.enable {
    # load nvidia driver for xorg and wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = {
      # modesetting is required for wayland compositors (hyprland, sway)
      modesetting.enable = true;

      # use the open source kernel module (for turing+ gpus, 2000 series and newer)
      # set to false if you have older gpu or experience issues
      open = false;

      # nvidia-settings gui
      nvidiaSettings = true;

      # power management (experimental)
      # helps with suspend/resume issues
      powerManagement = {
        enable = false;
        # fine-grained power management (turns off gpu when not in use)
        # experimental and only works on turing+ gpus
        finegrained = false;
      };

      # optimus prime configuration for laptops with hybrid graphics
      # prime = {
      #   sync mode: nvidia gpu always active (best performance, more power)
      #   sync.enable = true;
      #
      #   offload mode: nvidia gpu only when needed (better battery)
      #   offload = {
      #     enable = true;
      #     enableOffloadCmd = true;  # adds `nvidia-offload` command
      #   };
      #
      #   bus ids from: lspci | grep -E 'VGA|3D'
      #   format: "PCI:X:Y:Z"
      #   nvidiaBusId = "PCI:1:0:0";
      #   intelBusId = "PCI:0:2:0";  # or amdgpuBusId for AMD igpu
      # };

      # driver package selection
      # stable, beta, production, vulkan_beta, legacy_470, legacy_390
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    environment.sessionVariables = {
      # force gbm backend for nvidia
      GBM_BACKEND = "nvidia-drm";

      # hardware cursors can be buggy on nvidia
      WLR_NO_HARDWARE_CURSORS = "1";

      # required for wayland
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";

      # enable wayland for electron apps
      NIXOS_OZONE_WL = "1";
    };

    # cuda support (uncomment if needed for ml/compute)
    # environment.systemPackages = with pkgs; [
    #   cudatoolkit
    #   cudaPackages.cudnn
    # ];
  };
}
