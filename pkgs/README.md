# Custom Packages and Overlays

## Usage

### Custom Packages (`pkgs/`)
This directory contains custom tools and scripts that are not part of upstream nixpkgs.

- **To run:** `nix run .#sys-update`
- **To build:** `nix build .#sys-update`

### Overlays (`overlays/`)
Overlays allow us to extend or modify the global `pkgs` set.

- `overlays.additions`: Adds our custom packages from `pkgs/` to `pkgs`.
  - Usage in config: `pkgs.sys-update`
- `overlays.modifications`: Patches or modifies upstream packages.

## Adding a New Package

1. Create a directory: `pkgs/my-tool/`
2. Create `default.nix`:
   ```nix
   { pkgs }:
   pkgs.writeShellScriptBin "my-tool" ''
     echo "Hello world"
   ''
   ```
3. Register it in `pkgs/default.nix`:
   ```nix
   my-tool = pkgs.callPackage ./my-tool { };
   ```
4. Use it anywhere as `pkgs.my-tool`.
