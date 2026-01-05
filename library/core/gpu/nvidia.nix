# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/hardware/video/nvidia.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/hardware/graphics.nix

{ config, lib, pkgs, ... }:
let
  cfg = config.library.core.gpu.nvidia;

  driverPackage =
    if cfg.legacy == "390" then config.boot.kernelPackages.nvidiaPackages.legacy_390
    else if cfg.legacy == "470" then config.boot.kernelPackages.nvidiaPackages.legacy_470
    else config.boot.kernelPackages.nvidiaPackages.stable;
in
{
  options.library.core.gpu.nvidia = {
    enable = lib.mkEnableOption "NVIDIA GPU support";

    # RTX 50xx (Blackwell) REQUIRES open = true
    # RTX 20xx+ works with either, but open is recommended
    open = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Use NVIDIA's open source kernel modules.
        REQUIRED for RTX 50xx (Blackwell).
        Recommended for RTX 20xx and newer.
        Set to false for GTX 10xx (Pascal) and older.
      '';
    };

    # for older GPUs that need legacy driver branches
    legacy = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "470" "390" ]);
      default = null;
      description = ''
        Use legacy driver branch for older GPUs.
        - "470": GTX 600/700/900/10xx series
        - "390": GTX 400/500 series, some 600/700
        - null: Use latest stable driver (RTX 20xx+)
      '';
    };

    # optimus prime for laptops with hybrid graphics
    prime = {
      enable = lib.mkEnableOption "Optimus/Prime hybrid graphics for laptops";

      mode = lib.mkOption {
        type = lib.types.enum [ "sync" "offload" ];
        default = "offload";
        description = ''
          - "sync": NVIDIA always active (best performance, more power)
          - "offload": NVIDIA on-demand (better battery)
        '';
      };

      nvidiaBusId = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "PCI bus ID of NVIDIA GPU (e.g., PCI:1:0:0). Find with: lspci | grep -E 'VGA|3D'";
      };

      intelBusId = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "PCI bus ID of Intel iGPU (e.g., PCI:0:2:0)";
      };

      amdBusId = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "PCI bus ID of AMD iGPU (for AMD+NVIDIA laptops)";
      };
    };
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

      # open source kernel module
      # REQUIRED for RTX 50xx, recommended for RTX 20xx+
      # must be false for GTX 10xx and older
      open = cfg.open;

      # nvidia-settings gui
      nvidiaSettings = true;

      # power management (experimental)
      powerManagement = {
        enable = false;

        # fine-grained power management (turns off gpu when not in use)
        # experimental and only works on turing+ gpus
        finegrained = false;
      };

      package = driverPackage;

      prime = lib.mkIf cfg.prime.enable (
        if cfg.prime.mode == "sync" then {
          sync.enable = true;
          nvidiaBusId = cfg.prime.nvidiaBusId;
          intelBusId = lib.mkIf (cfg.prime.intelBusId != "") cfg.prime.intelBusId;
          amdgpuBusId = lib.mkIf (cfg.prime.amdBusId != "") cfg.prime.amdBusId;
        } else {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          nvidiaBusId = cfg.prime.nvidiaBusId;
          intelBusId = lib.mkIf (cfg.prime.intelBusId != "") cfg.prime.intelBusId;
          amdgpuBusId = lib.mkIf (cfg.prime.amdBusId != "") cfg.prime.amdBusId;
        }
      );
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
