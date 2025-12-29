{ config, pkgs, ... }: {
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    memoryMax = 8192;
    priority = 100;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
  };
}
