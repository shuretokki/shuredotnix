{ config, lib, ... }:
let
  nvidia = config.library.core.gpu.nvidia.enable;
  amd = config.library.core.gpu.amd.enable;
in
{
  imports = [
    ./nvidia.nix
    ./amd.nix
  ];

  config.assertions = [
    {
      assertion = !(nvidia && amd);
      message = "cannot enable both nvidia and amd gpu modules simultaneously";
    }
  ];
}
