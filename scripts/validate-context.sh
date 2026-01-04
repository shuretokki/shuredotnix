#!/usr/bin/env bash
# scripts/validate-context.sh

ERRORS=0

validate_index() {
    index_file="$1"
    dir="$2"

    # Check if every markdown file in the dir is listed in the index
    for doc in "$dir"/*.md; do
        basename=$(basename "$doc")
        # Skip the index file itself
        if [[ "$basename" == "000_"* ]]; then continue; fi

        # Check against both filename and filename without extension
        if ! grep -q "$basename" "$index_file" && ! grep -q "${basename%.md}" "$index_file"; then
            echo "missing in index: $basename not found in $index_file"
            ERRORS=$((ERRORS+1))
        fi
    done
}

validate_index ".sym_context/domain_knowledge/000_domain_atlas.md" ".sym_context/domain_knowledge"
validate_index ".sym_context/ADR/000_decision_ledger.md" ".sym_context/ADR"
validate_index ".sym_context/troubleshooting/000_troubleshooting_index.md" ".sym_context/troubleshooting"

if [ $ERRORS -eq 0 ]; then
    exit 0
else
    exit 1
fi
