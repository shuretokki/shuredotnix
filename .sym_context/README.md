# .sym_context — Context Repository

This folder stores decisions, domain knowledge, and patterns so that readers understand *why* the code is written the way it is.

---

## Folder Structure

```
.sym_context/
├── ADR/ # Architecture Decision Records
├── domain_knowledge/ # System logic & how things work
├── conventions/ # Code style & patterns
├── troubleshooting/ # Runbooks for common issues
└── findings/ # Active research (scratch pad)
```

---

## Which Folder Do I Need?

```
"I need to understand..."
          │
          ├─── "Why did we choose X over Y?"
          │           └─► ADR/
          │
          ├─── "How does vars.nix / module X work?"
          │           └─► domain_knowledge/
          │
          ├─── "What's the code style for .nix files?"
          │           └─► conventions/
          │
          ├─── "NixOS rebuild failed, what do I do?"
          │           └─► troubleshooting/
          │
          └─── "I'm researching something new..."
                      └─► findings/000_In_Progress/
```

---

## Quick Start

| I want to... | Start here |
|--------------|------------|
| Understand the config structure | `domain_knowledge/DK_001_vars_system.md` |
| Know the Nix documentation style | `conventions/CON_001_nix_file_style.md` |
| Fix a rebuild error | `troubleshooting/TS_001_common_rebuild_errors.md` |
| Understand this context system | `domain_knowledge/DK_002_context_system_analysis.md` |

---

## Contributing to Context

**When to create a file:**
- **ADR:** You made a significant tool/architecture choice
- **DK:** You explained complex logic that spans multiple files
- **Convention:** You established a new pattern
- **Troubleshooting:** You solved a cryptic error
- **Finding:** You're actively researching (move to ADR/DK when done)

**Always update the index (`000_*.md`) when adding files!**
