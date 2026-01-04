---
tags: [automation, github, ci/cd, analysis]
---

# DK-003: GitHub Automation Ecosystem Analysis

**Related Code:** `.github/workflows/`
**Last Updated:** 2026-01-04

## Definition
This analysis covers the lifecycle of the GitHub Actions automation suite for this NixOS repository, detailing how human inputs trigger automated responses and identifying potential failure modes.

---

## The Automation Lifecycle Flow

### 1. The Git Push Loop (CI)
```
USER                 GITHUB                      OUTCOME
┌───────┐            ┌────────────────────┐      ┌─────────────────┐
│ PUSH  │ ─────────► │ ci.yml             │ ───► │   Green Check   │
└───────┘            │ • Install Nix      │      │ (Confidence)    │
                     │ • Flake Check      │      │                 │
                     │ • Build Host       │ ───► │   Red X         │
                     └────────────────────┘      │ (Broken Config) │
```

### 2. The Auto-Update Loop (Weekly)
```
SCHEDULE             GITHUB                      USER ACTION
┌───────┐            ┌────────────────────┐      ┌─────────────────┐
│ TIMER │ ─────────► │ update.yml         │ ───► │ Review PR       │
└───────┘            │ • Update Lockfile  │      │ • Wait for CI   │
                     │ • Create PR        │      │ • Merge         │
                     └────────────────────┘      └─────────────────┘
```

### 3. The Contribution Loop (Triage)
```
CONTRIBUTOR          GITHUB                      MAINTAINER
┌──────────┐         ┌────────────────────┐      ┌─────────────────┐
│ OPEN PR  │ ──────► │ labeler.yml        │ ───► │ Sees Labels     │
└──────────┘         │ • Reads Files      │      │ "Ah, docs only" │
                     │ • Applies Label    │      └─────────────────┘
                     └────────────────────┘
```

---

## Weaknesses & Edge Cases

### 1. The "Cache Miss" Build Timeout (HIGH RISK)
**Scenario:** You change a core package (e.g., compile a custom Firefox).
**Symptom:** GitHub Action runs for 6 hours then times out or crashes.
**Weakness:** GitHub Free runners have 2 cores / 7GB RAM. Using Nix to build huge software on them is impossible.
**Mitigation:** `binary-cache` usage (Cachix) or excluding heavy builds from CI.

### 2. The "Update Breakage" (MEDIUM RISK)
**Scenario:** `update.yml` bumps `nixpkgs`. The build theoretically passes, but your Wifi stops working.
**Weakness:** CI only checks if code *compiles*, not if it *works* on hardware.
**Mitigation:** Only manual verification or complex VM tests (very long runtime) can solve this.

### 3. The "Flake Check" False Confidence (MEDIUM RISK)
**Scenario:** CI says "Green", but you forgot to `git add` a new file.
**Weakness:** `nix flake check` mostly checks valid syntax, it doesn't know about file system state outside git.
**Mitigation:** The `ci.yml` build step catches verify imports, but subtle logic bugs slip through.

### 4. Rate Limiting (LOW RISK)
**Scenario:** Pipeline fails with "403 Forbidden" or "API Rate Limit".
**Weakness:** GitHub limits API calls from Actions.
**Mitigation:** Automatically handled by `GITHUB_TOKEN`, usually fine for personal repos.

---

## Strategic Decisions (ADR Context)

| Decision | Why? |
|----------|------|
| **Use `install-nix-action`** | Industry standard, robust caching, reliable. |
| **Weekly Updates** | Daily is too noisy, monthly is too large. Weekly balances drift vs. maintenance. |
| **No Auto-Merge** | **Never** auto-merge system updates. Breaking changes need human eyes. |
