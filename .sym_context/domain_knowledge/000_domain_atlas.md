# Domain Knowledge Atlas

This folder contains **Domain Knowledge** files — documentation of business logic, system design, and how things work in this NixOS configuration.

## Purpose
- Explain complex logic that spans multiple modules
- Document custom abstractions (like `vars.nix`)
- Clarify how different NixOS options interact
- Provide context for readers

## Index

| ID | Concept | Related Code |
|----|---------|--------------|
| 001 | vars.nix system | `vars.nix` |
| 002 | Context system analysis | `.sym_context/`, `.agent/rules/` |
| 003 | GitHub Automation Analysis | `.github/workflows/` |

## How to Add a New DK File

1. Copy the template below
2. Create `DK_XXX_concept_name.md`
3. Fill in the sections
4. **Update this index**

---

## Template

```markdown
# DK-XXX: [Concept Name]

**Related Code:** `library/core/...`
**Last Updated:** YYYY-MM-DD

## Definition
[One sentence definition of this concept]

## How It Works
[Detailed explanation]

## Business Rules / Constraints
1. [Rule 1]
2. [Rule 2]

## Edge Cases
- What happens if X fails?
- What happens on a fresh install?

## Related Files
- `path/to/file1.nix`
- `path/to/file2.nix`
```
