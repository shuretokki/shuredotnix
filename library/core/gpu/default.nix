{ config, lib, ... }:
let
  nvidia = config.library.core.gpu.nvidia.enable;
  amd = config.library.core.gpu.amd.enable;
  prime = config.library.core.gpu.nvidia.prime.enable;
in
{
  imports = [
    ./nvidia.nix
    ./amd.nix
  ];

  config.assertions = [
    {
      # allow both if prime is enabled (AMD iGPU + NVIDIA dGPU laptop)
      assertion = !(nvidia && amd && !prime);
      message = ''
        Cannot enable both nvidia and amd gpu modules simultaneously.
        If you have an AMD iGPU + NVIDIA dGPU laptop, enable:
          library.core.gpu.nvidia.prime.enable = true
          library.core.gpu.nvidia.prime.amdBusId = "PCI:X:Y:Z"
      '';
    }
  ];

  config.warnings = lib.mkIf (nvidia && amd && prime) [
    "GPU: Both AMD and NVIDIA enabled with prime. Ensure prime.amdBusId is set correctly."
  ];
}
