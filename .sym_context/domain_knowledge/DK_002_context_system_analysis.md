---
tags: [meta, documentation, analysis]
---

# DK-002: Context System Flow Analysis

**Related Code:** `.sym_context/`, `.agent/rules/project-rules.md`
**Last Updated:** 2026-01-04

## Definition
This document analyzes the interaction between the `.sym_context` documentation system and the NixOS configuration, identifying edge cases, weaknesses, and mitigation strategies.

---

## User/Machine Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           USER REQUEST                                       │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ PHASE 0: PLANNING                                                            │
│ ┌─────────────────────────────────────────────────────────────────────────┐ │
│ │ 1. Read .sym_context/domain_knowledge/* to understand existing system   │ │
│ │ 2. Check if request affects documented systems                          │ │
│ │ 3. Flag which DK/ADR files may need updates                             │ │
│ └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ EXECUTION: Code Changes                                                      │
│ ┌─────────────────────────────────────────────────────────────────────────┐ │
│ │ For each file modified:                                                  │ │
│ │   1. Edit code                                                           │ │
│ │   2. git add <file> -> git commit                                        │ │
│ │   3. Track: "Does this affect a documented system?"                      │ │
│ └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ POST-EXECUTION: Context Sync                                                 │
│ ┌─────────────────────────────────────────────────────────────────────────┐ │
│ │ Checklist:                                                               │ │
│ │ - Does change affect vars.nix? -> Update DK_001_vars_system.md           │ │
│ │ - Does change contradict existing doc? -> Fix the doc                    │ │
│ │ - New module added? -> Consider new DK file                              │ │
│ │ - New error encountered & solved? -> Add to troubleshooting/             │ │
│ │ - Major decision made? -> Create ADR                                     │ │
│ └─────────────────────────────────────────────────────────────────────────┘ │
│                                    │                                         │
│                                    ▼                                         │
│              git add .sym_context/ && git commit -m "update context docs"    │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
                              ┌──────────┐
                              │   DONE   │
                              └──────────┘
```

---

## Edge Cases & Weaknesses

### 1. Stale Documentation (HIGH RISK)

**Scenario:** Code is modified but `.sym_context/` isn't updated.

**Why it happens:**
- Human forgets to update docs
- AI session ends before docs are updated
- Change seems "minor" but has ripple effects

**Mitigation:**
- Maintenance Protocol in rules (checklist before task completion)
- **Weakness:** No automated validation; relies on discipline
- **Future improvement:** A `nix run .#validate-context` script that checks if documented files exist

---

### 2. Context Overload (MEDIUM RISK)

**Scenario:** Too many DK/ADR files make it hard to find relevant info.

**Why it happens:**
- Over-documentation of trivial decisions
- Files not organized by topic

**Mitigation:**
- Complexity threshold rule (don't over-document)
- Index files (000_*.md) in each folder
- **Weakness:** No tagging/search system
- **Future improvement:** Add `tags:` frontmatter to each file

---

### 3. Context Not Read (MEDIUM RISK)

**Scenario:** Contributor (human or AI) makes changes without reading existing context.

**Why it happens:**
- New session with no memory
- Large codebase, context files overlooked

**Mitigation:**
- PHASE 0 in rules mandates reading context first
- Related Code links in DK files point to affected code
- **Weakness:** Reader must know WHICH context file to read
- **Future improvement:** A `README.md` in `.sym_context/` with a decision tree

---

### 4. Multi-Machine Sync Issues (LOW RISK)

**Scenario:** Context is machine-specific and breaks on other devices.

**Why it happens:**
- Hardcoded paths in documentation
- Machine-specific troubleshooting steps

**Mitigation:**
- `vars.nix` abstraction already handles user/host differences
- Docs reference `vars.username` not literal usernames
- **Future improvement:** None needed currently

---

### 5. Orphaned Context Files (MEDIUM RISK)

**Scenario:** Code is deleted but its DK/ADR file remains.

**Why it happens:**
- Module removed during refactor
- No backlink from code -> context

**Mitigation:**
- DK files have `Related Files:` section
- **Weakness:** No automated orphan detection
- **Future improvement:** Script to check if `Related Files:` paths exist

---

### 6. Session Boundary Problem (HIGH RISK)

**Scenario:** AI session ends mid-task; context update is forgotten.

**Why it happens:**
- User closes chat before confirmation
- Long task spans multiple sessions

**Mitigation:**
- Checklist at end of task in rules
- **Weakness:** If session ends abruptly, no reminder
- **Future improvement:** User habit: "Always end session with context check"

---

### 7. Conflicting ADRs (LOW RISK)

**Scenario:** Two ADRs give contradictory guidance.

**Why it happens:**
- Newer decision didn't deprecate old one
- Different authors, no cross-referencing

**Mitigation:**
- ADR `Status:` field (Proposed | Accepted | **Deprecated**)
- Single maintainer currently (you)
- **Future improvement:** ADRs should link to superseded ADRs

---

## Risk Summary Matrix

| Risk | Probability | Impact | Mitigation Quality |
|------|-------------|--------|---------------------|
| Stale Documentation | High | High | Partial (relies on discipline) |
| Context Overload | Medium | Medium | Good (threshold rules) |
| Context Not Read | Medium | High | Partial (no discovery system) |
| Multi-Machine Issues | Low | Medium | Excellent (vars.nix) |
| Orphaned Files | Medium | Low | Partial (manual tracking) |
| Session Boundary | High | Medium | Partial (checklist only) |
| Conflicting ADRs | Low | Medium | Good (status field) |

---

## Recommended Improvements (Priority Order)

### Immediate (Add to workflow)
1. **End-of-session habit:** "Did I update context?" becomes a verbal/mental checkpoint

### Short-term (Create files)
2. **`.sym_context/README.md`** — Decision tree for "which file do I read?"
3. **Index update protocol** — When adding DK/ADR, also update the 000_*.md index

### Long-term (Scripts/automation)
4. **`validate-context.sh`** — Check for orphaned files, missing indexes
5. **Tags/search** — Add `tags:` to frontmatter for filtering

---

## Related Files
- `.agent/rules/project-rules.md` — PHASE 5 defines context rules
- `.sym_context/*/000_*.md` — Index files
- `vars.nix` — Central config that DK_001 documents
