#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# serve_metamaplite.sh — start zero‑install MetaMapLite web UI from /applications/nlp
# Usage: ./serve_metamaplite.sh [port]
# =============================================================================

PORT="${1:-8000}"
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[*] Serving NLP UI from $BASE_DIR on http://localhost:$PORT"
echo "[*] Press Ctrl‑C to stop."

cd "$BASE_DIR"
python3 -m http.server --cgi "$PORT"
