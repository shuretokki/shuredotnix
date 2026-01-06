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
- `programs.git.userName` -> WRONG, use `programs.git.settings.user.name`
- `programs.git.extraConfig` -> WRONG, use `programs.git.settings`
5. **ASK for docs**: Before writing code for new tools, ask user to provide current documentation.
6. **PRIORITIZE user context**: If user provides code snippets or docs, use that over my training data.
7. **VERIFY versions**: Never assume versions. Run `git ls-remote` or check provided docs.
8. **TRUST evidence**: If training data says v4 but user file says v6, use v6.
**Rule**: If the user's code builds without errors, assume it's correct even if I don't recognize it.
**Corrections Database**: Check `docs/.sym_context/findings/corrections/` for known outdated patterns.

---

### 📖 MANDATORY PRE-FLIGHT: Read Corrections Database
**Before writing any code involving external tools, libraries, or patterns:**
1. Read [docs/.sym_context/findings/corrections/COR002.md](cci:7://file:///home/shure/shuredotnix/docs/.sym_context/findings/corrections/COR002.md:0:0-0:0) (Assume Outdated protocol)
2. Check `docs/.sym_context/findings/corrections/` for tool-specific corrections
3. Apply the "Verification Hierarchy" defined in COR002

---

## ⚡ PHASE 1: THE ATOMIC WORKFLOW (EXECUTION)
Once authorized to code, you must strictly follow this **Write-Commit Loop** to ensure safety.

# Atomic Commit Protocol

For **EACH** logical change (feature, fix, or refactor), perform these steps sequentially:

### 1. EDIT
Write or update code across **all files** necessary for one single logical unit of work. The system must be buildable/runnable after this step.

### 2. ADD
Stage **only** the files related to this specific change.
`git add <file_A> <file_B>`

### 3. COMMIT
Run the commit command using the **Strict Commit Rules**:
* **4 words maximum**
* **All lowercase**
* **One logical unit per commit**

`git commit -m "<message>"`

### 4. REPEAT
Verify the commit succeeds, then move to the next logical task.

---

**📁 EXCEPTION: `docs/.sym_context/` folder**
For files inside `docs/.sym_context/`, you may batch multiple files into a single commit:
```bash
git add docs/.sym_context/
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

1.  **Flexibility & Accessibility**: This config is for public/multi-device ucse. Avoid hardcoded paths that break on other machines.
2.  **Latest Nix Information**: Prioritize **NixOS 25.xx/26.xx** standards.
    * *Example:* Use newer `lib.mkOption` types.
    * *Avoid:* Deprecated commands or syntax.
3.  **Safety First**:
    * If touching `boot.*`, `fileSystems.*`, or `users.*`, add a **BOLD WARNING** in the chat before executing.
4.  **Modularization**: Keep `configuration.nix` clean. Move logic to `modules/`.
5.  **Conventions**:
    * **ALWAYS** check `docs/.sym_context/conventions/` before adhering to style.
    * **Documentation Style**: Follow `CON001` (No emojis, no ASCII diagrams).

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

## 📚 PHASE 5: CONTEXT MAINTENANCE

### A. The `.sym_context` Folder
This project uses a **Context Repository** at `docs/.sym_context/` as the single source of truth for architectural decisions and domain knowledge.

```
docs/.sym_context/
├── ADR/                    # Architecture Decision Records
├── domain_knowledge/       # Business logic & system explanations
├── conventions/            # Code style & patterns
├── troubleshooting/        # Runbooks for common issues
└── findings/               # Active research (in-progress)
```

### B. Proactive Documentation Triggers
**Create a DK or ADR file when:**
- Making a significant library/tool choice.
- Explaining complex logic that spans multiple modules.
- Clarifying how different NixOS options interact.

### C. File Naming Convention
Files must use strict ID-based naming without titles. Index files are always `000.md`.
- `ADR/ADR001.md`
- `domain_knowledge/DK001.md`
- `conventions/CON001.md`
- `troubleshooting/TS001.md`

### D. Complexity Threshold (Rule of Thumb)
**DO NOT over-document.**
- **Avoid:** Comments for `enable = true` or self-descriptive attributes.
- **Required:** Non-default values, side effects, alternative values, and magic numbers.
- **Forbidden:** ASCII Diagrams (Use descriptive text flows).

### E. Context Maintenance Protocol (MANDATORY)
**This is NOT optional. After EVERY code change**, you MUST:

1. **Evaluate** the change against these triggers (answer YES/NO mentally):
   - Does this introduce a NEW module or system? → **Create DK file**
   - Does this change HOW something works? → **Update existing DK file**
   - Did I make a CHOICE between alternatives? → **Create ADR file**
   - Did I encounter and fix an ERROR? → **Create TS file**
   - Does this change vars.nix or library.*? → **Update DK001.md**
   - Does this change display/theming? → **Update DK005.md**
   - Does this change GPU modules? → **Update DK006.md**

2. **Act** immediately after the code commit:
   - If ANY trigger is YES → Create/update the context file in the SAME turn
   - Do NOT wait for user to remind you
   - Do NOT batch documentation for "later"

3. **Stage but HOLD commit** until user verifies code works:
   ```bash
   git add docs/.sym_context/
   # DO NOT COMMIT YET - wait for user confirmation
   ```

4. **Commit ONLY after** user confirms the code change works correctly:
   ```bash
   git commit -m "update context docs"
   ```
   
   **Rationale:** Don't document something that might break. If the code fails, you may need to revise both code AND documentation.

### F. Documentation Decision Matrix
| Change Type | Action Required |
|-------------|-----------------|
| New module created | Create DK file |
| Module significantly changed | Update existing DK |
| New option pattern added | Update DK or create new |
| Bug fixed after debugging | Create TS file |
| Architecture decision made | Create ADR file |
| Workaround implemented | Create TS file |
| CI/build issue resolved | Create TS file |
| Convention changed | Update CON file |

### G. Self-Check Before Completing Task
**Before calling notify_user or ending work**, verify:
- [ ] Did I create/update docs for any new systems?
- [ ] Did I add troubleshooting for any errors I solved?
- [ ] Is DK001 current if I touched vars.nix?
- [ ] Are the 000.md indexes updated?

**If ANY box is NO, fix it before ending.**
## 🔀 PHASE 1B: GIT STATE MANAGEMENT

### Branch Naming Convention
| Prefix | Format | Use Case |
|--------|--------|----------|
| `feature/` | `feature/T-{id}-{desc}` | New features |
| `bugfix/` | `bugfix/T-{id}-{desc}` | Bug fixes |
| `hotfix/` | `hotfix/T-{id}-{desc}` | Urgent production fixes |
| `release/` | `release/v{version}` | Release branches |
| `docs/` | `docs/T-{id}-{desc}` | Documentation only |

### State Checks
**Before creating branch:**
```bash
git branch | grep "^  feat/name" && echo "Branch exists!"
```

**Before committing:**
```bash
git branch --show-current  # Verify correct branch
```

**On user cancellation:**
```bash
git stash push -m "WIP: $(git branch --show-current)"
git checkout main
```

### Pre-Commit Handling
- **On failure:** Read `/tmp/pre-commit-output.log` for full error
- **Emergency bypass:** `git commit --no-verify -m "emergency: reason"`
- **Timeout (5min):** Check network, reduce eval scope

### Bisect Protocol
```bash
git bisect start
git bisect bad HEAD
git bisect good <tag-or-commit>
git bisect run bash -c 'for i in {1..3}; do nix flake check && exit 0; done; exit 1'
git bisect reset  # ALWAYS cleanup
```

### Conflict Resolution
On merge conflict: **STOP** and use `notify_user`:
- List conflicting files
- Ask user to resolve or provide guidance

---

## 🛠️ MODERN CLI TOOLS (AI PREFERRED)

Use these modern alternatives instead of legacy bash tools:

| Legacy | Modern | Command | Purpose |
|--------|--------|---------|---------|
| `sed` | `sd` | `sd 'pattern' 'replacement' file` | Text replacement |
| `grep` | `rg` (ripgrep) | `rg 'pattern' path` | Text search |
| `ls` | `eza` | `eza -la --git` | Directory listing |
| `find` | `fd` | `fd 'pattern' path` | File finding |
| `diff` | `delta` | `git diff \| delta` | Diff viewing |

### Why Use Modern Tools
- **Better error messages** (clearer for AI parsing)
- **Faster execution** (Rust-based)
- **Simpler syntax** (fewer flags needed)
- **Git-aware** (respects .gitignore by default)

### Examples
```bash
# Replace text in file (sd is simpler than sed)
sd 'old_pattern' 'new_text' file.nix

# Search with context
rg 'vars.username' --context 3

# Find nix files
fd '\.nix$' library/

# Pretty git diff
git diff | delta --side-by-side
```
