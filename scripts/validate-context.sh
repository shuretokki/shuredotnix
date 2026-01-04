#!/usr/bin/env bash
# scripts/validate-context.sh

ERRORS=0

val() {
    index_file="$1"
    dir="$2"

    for doc in "$dir"/*.md; do
        basename=$(basename "$doc")
        if [[ "$basename" == "000.md" ]]; then continue; fi
        if ! grep -q "$basename" "$index_file" && ! grep -q "${basename%.md}" "$index_file"; then
            echo "missing in index: $basename not found in $index_file"
            ERRORS=$((ERRORS+1))
        fi
    done
}

val "docs/.sym_context/domain_knowledge/000.md" "docs/.sym_context/domain_knowledge"
val "docs/.sym_context/ADR/000.md" "docs/.sym_context/ADR"
val "docs/.sym_context/troubleshooting/000.md" "docs/.sym_context/troubleshooting"

if [ $ERRORS -eq 0 ]; then
    exit 0
else
    exit 1
fi
