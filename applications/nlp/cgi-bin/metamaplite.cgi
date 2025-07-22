#!/usr/bin/env bash
set -euo pipefail

# --- check debug flag from query string ---
DEBUG=0
case "${QUERY_STRING:-}" in
    *debug=1*) DEBUG=1;;
esac

# --- CGI headers ---
if [ "$DEBUG" = 1 ]; then
    echo "Content-Type: text/plain"
else
    echo "Content-Type: application/json"
fi
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
        debug) DEBUG=1;;
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

if [ "$DEBUG" = 1 ]; then
    echo "# cmd: ${cmd[*]}" >&2
    printf '%s\n' "$TEXT" | "${cmd[@]}" 2>&1
else
    printf '%s\n' "$TEXT" | "${cmd[@]}"
fi
