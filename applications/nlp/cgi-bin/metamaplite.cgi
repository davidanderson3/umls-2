#!/usr/bin/env bash
set -euo pipefail

# --- CGI headers ---
echo "Content-Type: application/json"
echo

# --- read POST body ---
read -n "${CONTENT_LENGTH:-0}" body

# --- URL‑decode the `text` field ---
TEXT=$(printf '%b' "${body//%/\\x}" | sed -e 's/^text=//')

# --- paths relative to /applications/nlp/cgi-bin ---
BASE="$(cd "$(dirname "$0")/.." && pwd)"
MM_SH="$BASE/metamaplite/metamaplite.sh"
INDEXDIR="$BASE/metamaplite/data/ivf/2022AB/USAbase"
MODELS="$BASE/metamaplite/data/models"

# --- run MetaMapLite ---
printf '%s\n' "$TEXT" \
  | "$MM_SH" --indexdir="$INDEXDIR" --modelsdir="$MODELS" --pipe --format=json
