---
tags: [conventions, style, nix]
---

# CON-001: NixOS Module Documentation Style

**Applies To:** All `.nix` module files in `library/`

## The Rule

Every NixOS module should follow a consistent documentation pattern that balances clarity with avoiding over-documentation.

## Structure

### 1. Source Links at Top
Link to the nixpkgs module source for reference:

```nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/hardware/bluetooth.nix
```

### 2. Inline Comments - ONLY When Needed

**Document when:**
- The value is **non-default** and the reason isn't obvious
- The option has **side effects** not clear from the name
- There are **alternative values** worth knowing
- External documentation is needed

**Don't document:**
- `enable = true` (obvious)
- Self-descriptive attribute names
- Anything where the comment restates the code

### 3. External Doc Links
When options have dedicated documentation:

```nix
# See: https://wiki.archlinux.org/title/PipeWire
```

### 4. Commented-Out Alternatives
Show what's possible without cluttering the active config:

```nix
# algorithm = "zstd";  # Best compression, requires kernel 5.x+
# algorithm = "lz4";   # Faster but less compression
```

### 5. Explain Magic Values

```nix
# 180 = aggressively use ZRAM (100-200 range for compressed swap)
"vm.swappiness" = 180;
```

## Examples

### ✅ Good

```nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/hardware/bluetooth.nix

{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    # HSP/HFP daemon for better headset mic support on some devices
    # Alternative to PulseAudio's native profile handling
    hsphfpd.enable = false;

    settings = {
      General = {
        # dual = Classic + Low Energy (default)
        # bredr = Classic only
        # le = Low Energy only (BLE devices)
        ControllerMode = "dual";
      };
    };
  };
}
```

### ❌ Bad

```nix
# Enable Bluetooth
hardware.bluetooth.enable = true;

# Power on when system boots
powerOnBoot = true;

# Set controller mode to dual
ControllerMode = "dual";
```

## Rationale

1. **Source links** — Immediate verification; readers know where to find the full option list
2. **Complexity threshold** — Reduces noise; comments that restate code are worse than no comments
3. **Alternatives as comments** — Documents possibilities without cluttering active config
4. **Magic values explained** — Numbers without context are meaningless 6 months later
