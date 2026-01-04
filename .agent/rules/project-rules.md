---
trigger: always_on
---

# ANTIGRAVITY AGENT PROTOCOL

## 🛑 PHASE 0: THE PRIME DIRECTIVE (PLANNING)
**DO NOT WRITE CODE YET.**
You must strictly follow this order of operations. You are currently in the **ARCHITECTING** phase.

1.  **Analyze**: Read the user request.
2.  **Verify**: Check package/option availability using the [Verification Protocol](#phase-3-verification-protocol) below.
3.  **Enhance the Native Plan**:
    * Do **NOT** create a new plan file.
    * You must **UPDATE** the system-generated `implementation_plan.md`.
    * **REQUIRED SECTIONS**: You must add these specific headers to the plan if they are missing:
        * `## Risks & Breaking Changes` (Especially for boot/users).
        * `## Verification Proof` (Paste the search.nixos.org links you visited and the results found).
        * `## File Impact List` (Exact paths of files to edit).
4.  **Wait**: You MUST output the plan content and wait for the user to say "GO" or "IMPLEMENT".

---

## 🚨 PHASE 0B: TRUST USER CODE OVER AI TRAINING DATA
**CRITICAL**: My training data may be outdated. When encountering unfamiliar option paths:
1. **DO NOT "fix" code that builds successfully** - If it builds, it's correct.
2. **TRUST build warnings over my knowledge** - Warnings tell the NEW option names.
3. **NEVER revert user code to older patterns** - e.g., don't change `settings.user.name` back to `userName`.
4. **When unsure**: Use web search or ask the user, don't assume my training data is correct.
**Examples of outdated patterns I might wrongly suggest**:
- `programs.git.userName` → WRONG, use `programs.git.settings.user.name`
- `programs.git.extraConfig` → WRONG, use `programs.git.settings`
**Rule**: If the user's code builds without errors, assume it's correct even if I don't recognize it.

---

## ⚡ PHASE 1: THE ATOMIC WORKFLOW (EXECUTION)
Once authorized to code, you must strictly follow this **Write-Commit Loop** to ensure safety.

**🚫 FORBIDDEN COMMANDS:**
* `git add .`
* `git add *`
* (These commands risk committing `.agent` files, which is strictly prohibited).

**✅ THE REQUIRED LOOP:**
For **EACH** file you need to modify, perform these steps sequentially before moving to the next file:

1.  **EDIT**: Write or update the code for **one single file** (e.g., `modules/hyprland.nix`).
2.  **ADD**: Immediately run `git add modules/hyprland.nix` (Use the specific filename ONLY).
3.  **COMMIT**: Immediately run `git commit -m "update hyprland config"`
    * **Rule**: 3 words maximum.
    * **Rule**: All lowercase.
    * **Rule**: One file per commit.
4.  **REPEAT**: Only after the commit succeeds, move to the next file.

**📁 EXCEPTION: `.sym_context/` folder**
For files inside `.sym_context/`, you may batch multiple files into a single commit:
```bash
git add .sym_context/
git commit -m "update context docs"
```
This reduces noise for documentation-only changes.

---

## 🔍 PHASE 2: VERIFICATION PROTOCOL (BROWSER USE)
**Before claiming a package exists**, you MUST use your Browser Tool to verify. Do not hallucinate package names.

* **For Packages:**
    * Query: `https://search.nixos.org/packages?channel=unstable&query=<INSERT_PACKAGE_NAME>`
* **For NixOS Options:**
    * Query: `https://search.nixos.org/options?channel=unstable&query=<INSERT_OPTION_NAME>`
* **For Home Manager:**
    * Query: `https://home-manager.dev/options` (Use page search)

**Decision Logic:**
* If found in standard repos -> Use `pkgs.name`.
* If **0 results** found -> Proceed to [Flake Decision Flow](#phase-4-flake-vs-nixpkgs-decision-flow).

---

## 🛠️ PHASE 3: CODING STANDARDS (NIXOS)

1.  **Flexibility & Accessibility**: This config is for public/multi-device use. Avoid hardcoded paths that break on other machines.
2.  **Latest Nix Information**: Prioritize **NixOS 25.xx/26.xx** standards.
    * *Example:* Use newer `lib.mkOption` types.
    * *Avoid:* Deprecated commands or syntax.
3.  **Safety First**:
    * If touching `boot.*`, `fileSystems.*`, or `users.*`, add a **BOLD WARNING** in the chat before executing.
4.  **Modularization**: Keep `configuration.nix` clean. Move logic to `modules/`.
5.  **Documentation**:
    * Add comments linking to the official Wiki or Doc URL for any complex config.
    * Example: `# Ref: https://wiki.hyprland.org/Configuring/Variables/`
    * **NO EMOJIS**: Maintain a professional, nonchalant tone. Do not use emojis in commit messages, documentation, or code comments.

---

## ⚖️ PHASE 4: FLAKE vs NIXPKGS DECISION FLOW

### A. When to Use Nixpkgs (Default)
**Criteria:**
1.  Package exists in `nh search <package>`.
2.  Module exists in standard options.
3.  Bleeding-edge version is NOT strictly required.

**Action**: Use `programs.moduleName.enable = true` or `environment.systemPackages`.

### B. When to Use Flake Input
**Criteria:**
1.  Package **NOT** in nixpkgs (Verified via nh or Browser).
2.  Module **NOT** in nixpkgs/HM (Verified via Browser).
3.  **Version Mismatch**: You need a specific version that matches the kernel or another tool (e.g., Hyprland plugins often require this).
4.  **Extensions**: You need specific themes/extensions from a separate flake (e.g., `vicinae-extensions`).

**Action**:
1.  Add to `flake.nix` inputs.
2.  Import module in `lib/default.nix` or relevant host config.
3.  **Log reason**: "Added input X because it is missing from unstable channel."

---

## 📚 PHASE 5: CONTEXT DOCUMENTATION

### A. The `.sym_context` Folder
This project uses a **Context Repository** at `.sym_context/` to store architectural decisions and domain knowledge.

```
.sym_context/
├── ADR/                    # Architecture Decision Records
├── domain_knowledge/       # Business logic & system explanations
├── conventions/            # Code style & patterns
├── troubleshooting/        # Runbooks for common issues
└── findings/               # Active research (in-progress)
```

### B. Proactive Documentation Triggers

**Create an ADR when:**
- Making a significant library/tool choice (e.g., "Why GRUB over systemd-boot")
- Changing system architecture (e.g., "Why modularize into bundlers")
- Adopting a new pattern that affects multiple files

**Create a DK (Domain Knowledge) file when:**
- Explaining complex logic that spans multiple modules
- Documenting the `vars.nix` system or custom abstractions
- Clarifying how different NixOS options interact

**Update existing docs when:**
- Code changes contradict existing documentation
- Adding new modules that affect documented systems

### C. File Templates

**ADR Template** (`.sym_context/ADR/ADR_XXX_title.md`):
```markdown
# ADR-XXX: [Title]

**Status:** Proposed | Accepted | Deprecated
**Date:** YYYY-MM-DD

## Context
[Why do we need to make this decision?]

## Decision
[The choice we made]

## Consequences
**Positive:** ...
**Negative:** ...
```

**DK Template** (`.sym_context/domain_knowledge/DK_XXX_title.md`):
```markdown
# DK-XXX: [Concept Name]

**Related Code:** `library/core/...`

## Definition
[One sentence definition]

## How It Works
[Explanation]

## Edge Cases
[What could go wrong?]
```

### D. Documentation Restriction: COMPLEXITY THRESHOLD

**⚠️ DO NOT over-document.** Only add comments when necessary.

**Document ONLY when:**
1. The value is **non-default** and the reason isn't obvious
2. The option has **side effects** not clear from the name
3. There are **alternative values** worth knowing
4. The option **interacts with other options** non-obviously
5. External documentation links are needed (Wiki, nixpkgs source)

**DO NOT document:**
- `enable = true` (self-explanatory)
- Self-descriptive attribute names like `powerOnBoot = true`
- Anything where the comment merely restates the code

**❌ BAD:**
```nix
# Enable Bluetooth
hardware.bluetooth.enable = true;
```

**✅ GOOD:**
```nix
hardware.bluetooth.enable = true;

# HSP/HFP daemon provides better headset mic support on some devices
# Alternative to PulseAudio's native profile handling
hsphfpd.enable = false;
```

### E. NixOS File Documentation Style

Every `.nix` module file should follow this pattern:

1. **Source links at top** — Link to nixpkgs module source
   ```nix
   # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/...
   ```

2. **External doc links inline** — When options have dedicated docs
   ```nix
   # See: https://wiki.archlinux.org/title/...
   ```

3. **Commented-out alternatives** — Show what's possible
   ```nix
   # algorithm = "zstd";  # Best compression, requires kernel 5.x+
   # algorithm = "lz4";   # Faster but less compression
   ```

4. **Explain magic values**
   ```nix
   # 180 = aggressively use ZRAM (100-200 range for compressed swap)
   "vm.swappiness" = 180;
   ```

### F. Context Maintenance Protocol

**After every code change**, you MUST:
1. **Check** if the change affects any documented system in `.sym_context/`
2. **Update** the relevant DK/ADR file **in the same session** if affected
3. **Create** a new DK file if you add a module that warrants documentation

**No Stale Docs Rule:**
If code contradicts a `.sym_context/` file, fixing the doc is **part of the task** — not optional.

**Checklist before completing any task:**
- [ ] Does this change affect `vars.nix`? → Update `DK_001_vars_system.md`
- [ ] Does this change a documented convention? → Update relevant `CON_XXX` file
- [ ] Did I encounter a new error and solve it? → Add to `troubleshooting/`
- [ ] Did I make an architectural choice? → Create an ADR
