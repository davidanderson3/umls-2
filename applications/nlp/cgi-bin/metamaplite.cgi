#!/usr/bin/env bash
set -euo pipefail

# --- CGI headers ---
echo "Content-Type: application/json"
echo

# --- read POST body ---
read -n "${CONTENT_LENGTH:-0}" body

# --- parse URL encoded form fields ---
declare -A params
IFS='&' read -ra pairs <<< "$body"
for pair in "${pairs[@]}"; do
    key=${pair%%=*}
    val=${pair#*=}
    val=${val//+/ }
    val=$(printf '%b' "${val//%/\\x}")
    params[$key]="$val"
done

TEXT=${params[text]:-}
RESTRICT_STS=${params[restrict_sts]:-}
RESTRICT_SOURCES=${params[restrict_sources]:-}
MAX_CANDIDATES=${params[max_candidates]:-}

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

if [[ -n "$RESTRICT_STS" ]]; then
  cmd+=(--restrict_to_sts="$RESTRICT_STS")
fi
if [[ -n "$RESTRICT_SOURCES" ]]; then
  cmd+=(--restrict_to_sources="$RESTRICT_SOURCES")
fi
if [[ -n "$MAX_CANDIDATES" ]]; then
  cmd+=(--max_entity_candidates="$MAX_CANDIDATES")
fi

printf '%s\n' "$TEXT" | "${cmd[@]}"
