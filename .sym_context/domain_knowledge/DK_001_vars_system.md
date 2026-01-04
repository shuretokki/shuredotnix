# DK-001: The vars.nix System

**Related Code:** `vars.nix`, all files in `library/`
**Last Updated:** 2026-01-04

## Definition
`vars.nix` is a centralized configuration file that holds user-specific and machine-specific settings, enabling the same NixOS configuration to work across multiple machines and users.

## How It Works

The file is imported at the flake level and passed through to all modules via `specialArgs`:

```nix
# In flake.nix or lib/default.nix
specialArgs = { vars = import ./vars.nix; };
```

Modules then access these values:

```nix
{ vars, ... }: {
  networking.hostName = vars.hostname;
  services.gvfs.enable = vars.features.desktop;
}
```

## Available Variables

| Variable | Type | Purpose |
|----------|------|---------|
| `username` | string | Primary user account name |
| `gitname` | string | Full name for git commits |
| `email` | string | Email for git and other tools |
| `browser` | string | Default browser (zen, chromium) |
| `terminal` | string | Default terminal emulator |
| `editor` | string | Default text editor |
| `fileManager` | string | Default file manager |
| `musicPlayer` | string | Default music app |
| `locale` | string | System locale (e.g., en_US.UTF-8) |
| `timezone` | string | System timezone |
| `theme` | string | Theme preset name |
| `features.cli` | bool | Enable CLI-focused modules |
| `features.desktop` | bool | Enable desktop/GUI modules |

## Design Decisions

1. **No hardcoded paths** — All user-specific paths use `vars.username`
2. **Feature flags** — `features.desktop` allows the same config on headless servers
3. **Default apps** — Centralized so changing browsers/editors is one-line

## Edge Cases

- **Fresh install:** User must update `vars.nix` before first rebuild
- **Multi-user:** Currently single-user focused; multi-user would need structural changes
- **hostname:** Not in vars.nix — defined per-host in `hosts/*/default.nix`

## Files That Use vars.nix

- `library/core/system.nix` — hostname, username
- `library/core/locale.nix` — locale, timezone
- `library/core/security.nix` — features.desktop
- `library/core/boot.nix` — features.desktop (os-prober)
- Most `library/home/` modules — default apps
