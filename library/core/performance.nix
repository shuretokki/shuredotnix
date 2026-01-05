# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/zram.nix
# in-memory compressed swap device for faster swapping than disk.
# see: https://www.kernel.org/doc/Documentation/blockdev/zram.txt

{ config, pkgs, ... }: {
  zramSwap = {
    enable = true;

    # maximum memory for ZRAM (as percentage of total RAM)
    # defaults to 50%
    memoryPercent = 50;

    # hard cap on ZRAM size (in MB)
    # the smaller of memoryPercent and memoryMax is used
    memoryMax = 8192;

    # swap priority (higher = used first before disk swap)
    # disk swap defaults to ~0, so 100+ ensures ZRAM is preferred
    priority = 100;

    # compression algorithm
    # "zstd": best balance of speed and compression (default, requires newer kernel)
    # "lz4": fast but less compression
    # "lzo": good compression but slower
    # algorithm = "zstd";

    # number of ZRAM devices (1 is usually enough)
    # swapDevices = 1;

    # Write incompressible pages to a backing device instead of keeping in RAM
    # writebackDevice = "/dev/zvol/pool/swap-writeback";
  };

  # prevent hanging during rebuild when ZRAM configuration changes
  systemd.services."systemd-zram-setup@zram0".stopIfChanged = false;


  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/sysctl.nix
  # Kernel tunables for ZRAM-optimized swapping behavior
  boot.kernel.sysctl = {
    # how aggressively the kernel swaps memory pages
    # - 0-100 for disk swap (default: 60)
    # - 100-200 for ZRAM (compressed RAM is faster than disk)
    # 180 = aggressively use ZRAM to free up physical RAM
    "vm.swappiness" = 180;

    # disable watermark boosting
    # not needed with ZRAM
    "vm.watermark_boost_factor" = 0;

    # how much memory to try to keep free (scale factor / 10000)
    # 125 = 1.25% of RAM kept free (default is ~10 = 0.1%)
    "vm.watermark_scale_factor" = 125;

    # pages to read ahead when swapping in
    # 0 = disable read-ahead
    # ZRAM is random-access, no benefit from read-ahead
    "vm.page-cluster" = 0;

    # improve compatibility with applications that allocate a lot of memory
    # like modern games (default: 65530)
    # "vm.max_map_count" = 1048576;

    # inotify limits for file watchers (large IDEs, file sync tools)
    # "fs.inotify.max_user_instances" = 524288;
    # "fs.inotify.max_user_watches" = 524288;
  };


  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/system/earlyoom.nix
  # kills memory-hungry processes before the system freezes
  services.earlyoom = {
    enable = true;

    # trigger SIGTERM when free memory drops below this percentage
    freeMemThreshold = 5;

    # trigger SIGTERM when free swap drops below this percentage
    # freeSwapThreshold = 10;

    # send SIGKILL when memory drops below this (default: half of freeMemThreshold)
    # freeMemKillThreshold = 2;

    # logging interval in seconds (0 to disable)
    # reportInterval = 3600;

    # send desktop notifications when a process is killed (requires systembus-notify)
    # WARNING: Can be DoS'd by other users if enabled on multi-user systems
    # enableNotifications = false;

    # prefer killing specific processes
    # extraArgs = [ "--prefer" "(^|/)(java|chromium)$" ];

    # avoid killing specific processes
    # extraArgs = [ "--avoid" "(^|/)(sshd|tmux)$" ];
  };
}
