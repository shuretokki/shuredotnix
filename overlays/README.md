# overlays

overlays modify or extend nixpkgs for this flake.

## structure

```
overlays/
└── default.nix      # exports: additions, modifications
```

## usage

overlays are automatically applied via `utils.mkHost`.

### additions

exposes custom packages from `pkgs/` to the system:
```nix
final: prev: import ../pkgs { pkgs = final; }
```

### modifications

patches or overrides upstream packages:
```nix
final: prev: {
  # example: pin a package version
  # somePackage = prev.somePackage.overrideAttrs { ... };
}
```

## adding a new overlay

1. edit `overlays/default.nix`
2. add to `additions` (for new packages) or `modifications` (for patches)
3. run `nix flake check` to verify
