# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/hardware/amdgpu.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/hardware/graphics.nix

{ config, lib, pkgs, ... }:
let
  cfg = config.library.core.gpu.amd;
in
{
  options.library.core.gpu.amd = {
    enable = lib.mkEnableOption "AMD GPU support";
  };

  config = lib.mkIf cfg.enable {
    # amdgpu uses open source drivers by default
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      # amdvlk (official AMD vulkan)
      # optional, mesa radv is default
      extraPackages = with pkgs; [
        # amdvlk

        # opencl support
        rocmPackages.clr.icd
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        # amdvlk  # 32-bit vulkan if needed
      ];
    };

    hardware.amdgpu = {
      # load amdgpu in initrd for early KMS
      # fixes resolution during boot
      initrd.enable = true;

      # enable amdgpu for older cards (HD 7000/8000 series)
      # forces amdgpu instead of radeon driver
      legacySupport.enable = false;

      # enable overdrive mode for overclocking
      # overdrive.enable = false;
    };

    environment.sessionVariables = {
      # enable wayland for electron apps
      NIXOS_OZONE_WL = "1";

      # vulkan driver selection
      # "RADV" = mesa radv (recommended for gaming)
      # "AMDVLK" = amd's official vulkan driver
      AMD_VULKAN_ICD = "RADV";
    };

    # rocm hip symlink for ml/compute workloads
    # systemd.tmpfiles.rules = [
    #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    # ];
  };
}
