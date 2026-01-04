---
tags: [troubleshooting, errors, rebuild]
---

# TS-001: Common NixOS Rebuild Errors

**Last Updated:** 2026-01-04
**Related Files:** Various

---

## Error: "infinite recursion encountered"

### Symptoms
```
error: infinite recursion encountered
       at /nix/store/.../eval.nix:...
```

### Root Cause
A module is importing itself, or two options depend on each other circularly.

### Solution
1. Check recent changes to module imports
2. Look for `config.X` references that depend on the option being defined
3. Use `lib.mkDefault` or `lib.mkOverride` to break the cycle

---

## Error: "collision between ... and ..."

### Symptoms
```
error: collision between `/nix/store/.../bin/foo' and `/nix/store/.../bin/foo'
```

### Root Cause
Two packages provide the same file (common with Home Manager and system packages).

### Solution
1. Remove the duplicate from either `environment.systemPackages` or `home.packages`
2. Or use `meta.priority` to prefer one version:
   ```nix
   (pkgs.foo.overrideAttrs (old: { meta.priority = 0; }))
   ```

---

## Error: "attribute 'X' missing"

### Symptoms
```
error: attribute 'somePackage' missing
       at /path/to/file.nix:42:5
```

### Root Cause
- Package name is misspelled
- Package doesn't exist in the current nixpkgs channel
- Package was removed or renamed

### Solution
1. Verify package exists: `nix search nixpkgs#packageName`
2. Check for typos
3. If removed, search for alternatives

---

## Error: "option does not exist"

### Symptoms
```
error: The option `services.foo.bar' does not exist.
```

### Root Cause
- Option was renamed in a newer NixOS version
- Module providing the option isn't imported
- Typo in option path

### Solution
1. Search NixOS options: https://search.nixos.org/options
2. Check if module needs to be imported
3. Read deprecation warnings from previous builds

---

## System won't boot after rebuild

### Symptoms
- Black screen after GRUB
- Kernel panic
- System hangs

### Solution
1. At GRUB menu, select a previous generation
2. Boot into the working generation
3. Investigate what changed: `nixos-rebuild dry-build`
4. Rollback if needed: `sudo nixos-rebuild switch --rollback`

### Prevention
- Keep multiple generations: `boot.loader.grub.configurationLimit = 10;`
- Test in VM first for risky changes
