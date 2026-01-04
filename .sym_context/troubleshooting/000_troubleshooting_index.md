# Troubleshooting Runbooks

This folder contains **troubleshooting guides** for common issues encountered with this NixOS configuration.

## Purpose
- Quick reference when things break
- Document solutions to cryptic NixOS errors
- Prevent re-researching the same problems

## Index

| ID | Issue | Symptoms |
|----|-------|----------|
| 001 | Common NixOS Rebuild Errors | Various build failures |

## How to Add a New Runbook

1. Encounter and solve a problem
2. Create `TS_XXX_issue_name.md`
3. Document the symptoms, cause, and solution
4. Update this index

---

## Template

```markdown
# TS-XXX: [Issue Name]

**Last Occurred:** YYYY-MM-DD
**Related Files:** `path/to/file.nix`

## Symptoms
[What error messages or behaviors indicate this problem?]

## Root Cause
[Why does this happen?]

## Solution
[Step-by-step fix]

## Prevention
[How to avoid this in the future]
```
