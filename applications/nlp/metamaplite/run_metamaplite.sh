#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# fetch-and-index-metamaplite-idempotent.sh
# Downloads MetaMapLite public RRF data and builds Lucene indexes,
# but skips download/extraction/indexing if already present.
# Usage: ./fetch-and-index-metamaplite-idempotent.sh <UTS_API_KEY> [<INDEX_DIR>] [<RRF_DIR>]
# Defaults:
#   INDEX_DIR = umls_indices
#   RRF_DIR   = umls_rrf
# =============================================================================

if [ "$#" -lt 1 ] || [ "$#" -gt 3 ]; then
  echo "Usage: $0 <UTS_API_KEY> [<INDEX_DIR>] [<RRF_DIR>]" >&2
  exit 1
fi

APIKEY="$1"
INDEX_DIR="${2:-umls_indices}"
RRF_DIR="${3:-umls_rrf}"
OUTZIP="public_mm_data_lite_usabase_2022ab.zip"
DOWNLOAD_URL="https://data.lhncbc.nlm.nih.gov/umls-restricted/ii/tools/MetaMap/download/metamaplite/public_mm_data_lite_usabase_2022ab.zip"
BUILD_SCRIPT="./build-umls-indexes.sh"

echo "[+] Starting fetch-and-index-metamaplite-idempotent"

# 1) Check for existing RRF files
echo "[*] Checking for UMLS RRF files in '$RRF_DIR'..."
if [ -d "$RRF_DIR" ] && \
   [ -s "$RRF_DIR/MRCONSO.RRF" ] && \
   [ -s "$RRF_DIR/MRSTY.RRF" ] && \
   [ -s "$RRF_DIR/MRSAT.RRF" ]; then
  echo "[!] Found existing RRF files. Skipping download and extraction."
else
  echo "[*] RRF files missing. Downloading ZIP via UTS API..."
  curl -sSL \
    "https://uts-ws.nlm.nih.gov/download?url=${DOWNLOAD_URL}&apiKey=${APIKEY}" \
    -o "$OUTZIP"
  echo "[*] Extracting ZIP to '$RRF_DIR'..."
  rm -rf "$RRF_DIR" && mkdir -p "$RRF_DIR"
  unzip -q "$OUTZIP" -d "$RRF_DIR"
  echo "[✓] Extraction complete."
fi

# 2) Check for existing indexes
echo "[*] Checking for existing Lucene indexes in '$INDEX_DIR'..."
if [ -d "$INDEX_DIR" ] && [ "$(ls -A "$INDEX_DIR")" ]; then
  echo "[!] Index directory already populated. Skipping indexing."
else
  echo "[*] Index directory empty or missing. Building indexes..."
  if [ ! -x "$BUILD_SCRIPT" ]; then
    echo "ERROR: Build script '$BUILD_SCRIPT' not found or not executable." >&2
    exit 1
  fi
  "$BUILD_SCRIPT" "$RRF_DIR" "$INDEX_DIR"
  echo "[✓] Indexing complete."
fi

echo "[✓] All done. RRF files in '$RRF_DIR'; indexes in '$INDEX_DIR'."
