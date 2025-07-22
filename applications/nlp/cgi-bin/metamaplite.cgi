#!/usr/bin/env bash
set -euo pipefail

# --- CGI headers ---
echo "Content-Type: application/json"
echo

# --- read POST body ---
read -n "${CONTENT_LENGTH:-0}" body

# --- parse URL encoded form fields ---
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

# --- paths relative to /applications/nlp/cgi-bin ---
BASE="$(cd "$(dirname "$0")/.." && pwd)"
MM_SH="$BASE/metamaplite/metamaplite.sh"
INDEXDIR="$BASE/metamaplite/data/ivf/2022AB/USAbase"
MODELS="$BASE/metamaplite/data/models"

# --- run MetaMapLite ---
cmd=("$MM_SH" \
      --indexdir="$INDEXDIR" \
      --modelsdir="$MODELS" \
      --pipe \
      --outputformat=json)

printf '%s\n' "$TEXT" | "${cmd[@]}"
