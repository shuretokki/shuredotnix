# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/hardware/video/amdgpu.nix
#
# amd gpu configuration for desktop/laptop systems.
# uses open source mesa drivers (amdgpu kernel module).

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

      # vulkan drivers for amd
      extraPackages = with pkgs; [
        amdvlk
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        amdvlk
      ];
    };

    # amdgpu kernel module options
    # boot.kernelParams = [
    #   # enable display core (dc) - usually default on
    #   "amdgpu.dc=1"
    #   # enable freesync/vrr
    #   "amdgpu.freesync_video=1"
    # ];

    # environment variables for amd
    environment.sessionVariables = {
      # enable wayland for electron apps
      NIXOS_OZONE_WL = "1";

      # vulkan driver selection (radv is usually better for gaming)
      # "radv" = mesa radv (recommended)
      # "amdvlk" = amd's official vulkan driver
      AMD_VULKAN_ICD = "RADV";
    };

    # rocm support for compute (uncomment if needed for ml/compute)
    # hardware.opengl.extraPackages = with pkgs; [
    #   rocmPackages.clr.icd
    # ];
    #
    # systemd.tmpfiles.rules = [
    #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    # ];
  };
}
