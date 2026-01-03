# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/zram.nix
# In-memory compressed swap device for faster swapping than disk.
# See: https://www.kernel.org/doc/Documentation/blockdev/zram.txt

{ config, pkgs, ... }: {
  zramSwap = {
    enable = true;

    # Maximum memory for ZRAM (as percentage of total RAM)
    # Defaults to 50%
    memoryPercent = 50;

    # Hard cap on ZRAM size (in MB)
    # The smaller of memoryPercent and memoryMax is used
    memoryMax = 8192;

    # Swap priority (higher = used first before disk swap)
    # Disk swap defaults to ~0, so 100+ ensures ZRAM is preferred
    priority = 100;

    # Compression algorithm
    # "zstd": Best balance of speed and compression (default, requires newer kernel)
    # "lz4": Fast but less compression
    # "lzo": Good compression but slower
    # algorithm = "zstd";

    # Number of ZRAM devices (1 is usually enough)
    # swapDevices = 1;

    # Write incompressible pages to a backing device instead of keeping in RAM
    # writebackDevice = "/dev/zvol/pool/swap-writeback";
  };

  # Prevent hanging during rebuild when ZRAM configuration changes
  systemd.services."systemd-zram-setup@zram0".stopIfChanged = false;


  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/sysctl.nix
  # Kernel tunables for ZRAM-optimized swapping behavior
  boot.kernel.sysctl = {
    # How aggressively the kernel swaps memory pages
    # - 0-100 for disk swap (default: 60)
    # - 100-200 for ZRAM (compressed RAM is faster than disk)
    # 180 = aggressively use ZRAM to free up physical RAM
    "vm.swappiness" = 180;

    # Disable watermark boosting
    # not needed with ZRAM
    "vm.watermark_boost_factor" = 0;

    # How much memory to try to keep free (scale factor / 10000)
    # 125 = 1.25% of RAM kept free (default is ~10 = 0.1%)
    "vm.watermark_scale_factor" = 125;

    # Pages to read ahead when swapping in
    # 0 = disable read-ahead
    # ZRAM is random-access, no benefit from read-ahead
    "vm.page-cluster" = 0;

    # Improve compatibility with applications that allocate a lot of memory
    # like modern games (default: 65530)
    # "vm.max_map_count" = 1048576;

    # inotify limits for file watchers (large IDEs, file sync tools)
    # "fs.inotify.max_user_instances" = 524288;
    # "fs.inotify.max_user_watches" = 524288;
  };


  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/system/earlyoom.nix
  # Kills memory-hungry processes before the system freezes
  services.earlyoom = {
    enable = true;

    # Trigger SIGTERM when free memory drops below this percentage
    freeMemThreshold = 5;

    # Trigger SIGTERM when free swap drops below this percentage
    # freeSwapThreshold = 10;

    # Send SIGKILL when memory drops below this (default: half of freeMemThreshold)
    # freeMemKillThreshold = 2;

    # Logging interval in seconds (0 to disable)
    # reportInterval = 3600;

    # Send desktop notifications when a process is killed (requires systembus-notify)
    # WARNING: Can be DoS'd by other users if enabled on multi-user systems
    # enableNotifications = false;

    # Prefer killing specific processes
    # extraArgs = [ "--prefer" "(^|/)(java|chromium)$" ];

    # Avoid killing specific processes
    # extraArgs = [ "--avoid" "(^|/)(sshd|tmux)$" ];
  };
}
