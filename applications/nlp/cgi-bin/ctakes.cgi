#!/usr/bin/env bash
set -euo pipefail

# CGI headers
echo "Content-Type: text/plain"
echo

# Read POST body
read -n "${CONTENT_LENGTH:-0}" body

# Parse URL encoded text field
TEXT=""
IFS='&' read -ra pairs <<< "$body"
for pair in "${pairs[@]}"; do
    key=${pair%%=*}
    val=${pair#*=}
    val=${val//+/ }
    val=$(printf '%b' "${val//%/\\x}")
    case "$key" in
        text) TEXT="$val";;
    esac
done

CTAKES_HOME="${CTAKES_HOME:-/opt/ctakes}"
PIPELINE="${CTAKES_PIPELINE:-$CTAKES_HOME/desc/ctakes-clinical-pipeline.xml}"

if [ ! -x "$CTAKES_HOME/bin/runClinicalPipeline.sh" ]; then
    echo "cTAKES not installed or CTAKES_HOME not set" >&2
    echo "Error: cTAKES not installed" && exit 0
fi

TMPDIR=$(mktemp -d)
INPUT=$TMPDIR/input.txt
OUTPUT=$TMPDIR/output

printf '%s\n' "$TEXT" > "$INPUT"

"$CTAKES_HOME/bin/runClinicalPipeline.sh" -i "$INPUT" -o "$OUTPUT" -desc "$PIPELINE" -log stdout 2>&1

cat "$OUTPUT"/* 2>/dev/null || true
rm -rf "$TMPDIR"
