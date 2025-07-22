#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# index.sh — download MetaMapLite JAR if needed, filter UMLS, and build clinical index
# Usage: cd /applications/nlp/metamaplite && ./index.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1) Locate or download the MetaMapLite standalone JAR
JAR="$(find "$SCRIPT_DIR" -maxdepth 1 -type f -name 'metamaplite-*-standalone.jar' | head -n1 || true)"
if [ -z "$JAR" ]; then
  VERSION="3.6.2rc8"
  TARBALL="MetaMapLite-${VERSION}.tar.bz2"
  URL="https://lhncbc.nlm.nih.gov/assets/files/metamaplite/${TARBALL}"
  echo "[*] No standalone JAR found. Downloading MetaMapLite ${VERSION}…"
  curl -sSL -o "$SCRIPT_DIR/$TARBALL" "$URL"

  echo "[*] Extracting archive…"
  tar xjf "$SCRIPT_DIR/$TARBALL" -C "$SCRIPT_DIR"

  echo "[*] Moving standalone JAR into place…"
  mv "$SCRIPT_DIR/MetaMapLite-${VERSION}/metamaplite-${VERSION}-standalone.jar" "$SCRIPT_DIR/"

  echo "[*] Cleaning up…"
  rm -rf "$SCRIPT_DIR/$TARBALL" "$SCRIPT_DIR/MetaMapLite-${VERSION}"

  JAR="$SCRIPT_DIR/metamaplite-${VERSION}-standalone.jar"
  echo "[✓] Downloaded and extracted $(basename "$JAR")"
else
  echo "[✓] Found MetaMapLite JAR: $(basename "$JAR")"
fi

# 2) Define paths and filenames
RRF_DIR="/data"
INDEX_DIR="$SCRIPT_DIR/umls_indices"
CUIS_LIST="$SCRIPT_DIR/clinical_cuis.txt"
FILTERED_MRCONSO="$SCRIPT_DIR/MRCONSO-clinical.RRF"
STUB_MRSAT="$SCRIPT_DIR/MRSAT-stub.RRF"

# 3) Skip if index already exists
if [ -d "$INDEX_DIR" ] && [ "$(find "$INDEX_DIR" -maxdepth 1 -type f | wc -l)" -gt 0 ]; then
  echo "[✓] Index already exists in $INDEX_DIR; nothing to do."
  exit 0
fi

echo "[*] Building clinical index in $INDEX_DIR…"
mkdir -p "$INDEX_DIR"

# 4) Extract CUIs for clinical semantic types
TUIS="T047 T184 T046 T121 T116 T023"
echo "[*] Extracting CUIs for TUIs: $TUIS"
awk -F'|' -v types="$TUIS" '
  BEGIN {
    split(types,a," "); for(i in a) keep[a[i]] = 1
  }
  keep[$4] { print $1 }
' "$RRF_DIR/MRSTY.RRF" | sort -u > "$CUIS_LIST"

# 5) Subset MRCONSO
echo "[*] Subsetting MRCONSO.RRF → $(basename "$FILTERED_MRCONSO")"
grep -Ff "$CUIS_LIST" "$RRF_DIR/MRCONSO.RRF" > "$FILTERED_MRCONSO"

# 6) Create empty MRSAT stub (tree‑codes not needed)
echo "[*] Creating empty MRSAT stub → $(basename "$STUB_MRSAT")"
: > "$STUB_MRSAT"

# 7) Run the index builder
echo "[*] Running CreateIndexes (this may take 30–45 min on a 16 GB MacBook)…"
time java -Xmx8g -cp "$JAR" \
  gov.nih.nlm.nls.metamap.dfbuilder.CreateIndexes \
    "$FILTERED_MRCONSO" \
    "$RRF_DIR/MRSTY.RRF" \
    "$STUB_MRSAT" \
    "$INDEX_DIR"

echo "[✓] Clinical index built at: $INDEX_DIR"
