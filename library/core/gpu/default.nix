{ config, lib, ... }:
let
  nvidia = config.library.core.gpu.nvidia.enable;
  amd = config.library.core.gpu.amd.enable;
  prime = config.library.core.gpu.nvidia.prime.enable;
  none = config.library.core.gpu.none;
in
{
  imports = [
    ./nvidia.nix
    ./amd.nix
  ];

  options.library.core.gpu.none = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Explicitly disable all GPU modules (for VMs or servers).";
  };

  config.assertions = [
    {
      assertion = !(nvidia && amd && !prime);
      message = ''
        [GPU] cannot enable both nvidia and amd simultaneously.
        If you have an AMD iGPU + NVIDIA dGPU laptop, enable:
          library.core.gpu.nvidia.prime.enable = true
          library.core.gpu.nvidia.prime.amdBusId = "PCI:X:Y:Z"
      '';
    }
    {
      assertion = nvidia || amd || none;
      message = ''
        [GPU] configuration required. Run 'detect-gpu' to generate config, or set:
          library.core.gpu.none = true
        if this system has no discrete GPU.
      '';
    }
  ];

  config.warnings = lib.mkIf (nvidia && amd && prime) [
    "[GPU] both AMD and NVIDIA enabled with prime. Ensure prime.amdBusId is set correctly."
  ];
}

