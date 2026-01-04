# Session Checklist

## Pre-Commit Gate

Run before committing:
```bash
./scripts/validate-context.sh
```

## Post-Commit Review

For EACH condition that is true, the action is REQUIRED:

| Condition | Action |
|-----------|--------|
| Modified `vars.nix` | Update `DK001.md` |
| Created file in `library/` | Add to relevant `000.md` index |
| Solved error (>5 min effort) | Create `TSXXX.md` |
| Made irreversible/multi-file decision | Create `ADRXXX.md` |
| Changed a documented convention | Update relevant `CONXXX.md` |

## Definitions

- **Module**: Any new `.nix` file in `library/`
- **Major decision**: Impacts multiple files OR is irreversible
- **Significant error**: Took more than 5 minutes to diagnose/fix

## Session End

Before final response:
1. Verify `git status` shows clean working tree
2. Report what was created/updated/skipped

Example output:
```
Checklist complete.
- Created: TS002.md, ADR003.md
- Updated: troubleshooting/000.md, ADR/000.md
- Skipped: DK001 (vars.nix unchanged)
```
