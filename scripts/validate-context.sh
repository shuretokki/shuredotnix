#!/usr/bin/env bash
# scripts/validate-context.sh

set -euo pipefail

CONTEXT="docs/.sym_context"
ERRORS=0

error() {
    echo "ERROR: $1"
    ERRORS=$((ERRORS+1))
}

warn() {
    echo "WARN: $1"
}

chk_idx() {
    local index_file="$1"
    local dir="$2"

    if [[ ! -f "$index_file" ]]; then
        error "Index file missing: $index_file"
        return
    fi

    for doc in "$dir"/*.md; do
        [[ -f "$doc" ]] || continue
        local basename=$(basename "$doc")
        [[ "$basename" == "000.md" ]] && continue

        if ! grep -q "$basename" "$index_file" && ! grep -q "${basename%.md}" "$index_file"; then
            error "Not indexed: $basename missing from $index_file"
        fi
    done
}

chk_orphans() {
    local index_file="$1"
    local dir="$2"
    local prefix="$3"

    grep -oE "${prefix}[0-9]+" "$index_file" 2>/dev/null | while read -r id; do
        if [[ ! -f "$dir/${id}.md" ]]; then
            error "Orphan entry: $id in $index_file but $dir/${id}.md doesn't exist"
        fi
    done
}

chk_todos() {
    local count=$(grep -r "TODO\|FIXME\|XXX" "$CONTEXT" --include="*.md" 2>/dev/null | wc -l)
    if [[ $count -gt 0 ]]; then
        warn "Found $count TODO/FIXME markers in context docs"
    fi
}

chk_conv() {
    local conv_dir="$CONTEXT/conventions"
    local conv_index="$conv_dir/000.md"

    if [[ -d "$conv_dir" ]]; then
        chk_idx "$conv_index" "$conv_dir"
        chk_orphans "$conv_index" "$conv_dir" "CON"
    fi
}

echo "Validating $CONTEXT..."

chk_idx "$CONTEXT/domain_knowledge/000.md" "$CONTEXT/domain_knowledge"
chk_orphans "$CONTEXT/domain_knowledge/000.md" "$CONTEXT/domain_knowledge" "DK"

chk_idx "$CONTEXT/ADR/000.md" "$CONTEXT/ADR"
chk_orphans "$CONTEXT/ADR/000.md" "$CONTEXT/ADR" "ADR"

chk_idx "$CONTEXT/troubleshooting/000.md" "$CONTEXT/troubleshooting"
chk_orphans "$CONTEXT/troubleshooting/000.md" "$CONTEXT/troubleshooting" "TS"

chk_conv
chk_todos

echo ""
if [[ $ERRORS -eq 0 ]]; then
    echo "Validation passed."
    exit 0
else
    echo "Validation failed with $ERRORS error(s)."
    exit 1
fi
