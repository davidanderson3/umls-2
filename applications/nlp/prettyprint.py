#!/usr/bin/env python3
"""Pretty print MetaMapLite JSON output as a table.

Usage:
    metamaplite.sh --pipe --outputformat json TEXT | prettyprint.py
    cat output.json | prettyprint.py

The script reads JSON from stdin and writes a simple table to stdout.
"""
import json
import sys
from typing import Iterable, Dict, Any


def iter_rows(data: Any) -> Iterable[Dict[str, str]]:
    """Yield rows with text, CUI, preferred name, semantic types, score, span."""
    if isinstance(data, dict) and "annotations" in data:
        ents = data["annotations"]
    elif isinstance(data, list):
        ents = data
    else:
        return []
    for ent in ents:
        text = ent.get("matchedtext") or ent.get("trigger") or ""
        begin = ent.get("start")
        length = ent.get("length")
        if begin is not None and length is not None:
            span = f"{begin}-{begin + length}"
        elif "span" in ent:
            s = ent["span"]
            span = f"{s.get('begin','')}-{s.get('end','')}"
        else:
            span = ""
        for ev in ent.get("evlist", []) or [ent]:
            info = ev.get("conceptinfo", ev)
            row = {
                "Text": text,
                "CUI": info.get("cui", ""),
                "Name": info.get("preferredname", info.get("conceptstring", "")),
                "Type": ",".join(info.get("semantictypes", [])),
                "Score": str(ev.get("score", "")),
                "Span": span,
            }
            yield row


def main() -> None:
    data = json.load(sys.stdin)
    rows = list(iter_rows(data))
    if not rows:
        print("No annotations.")
        return
    headers = ["Text", "CUI", "Name", "Type", "Score", "Span"]
    print("\t".join(headers))
    for r in rows:
        print("\t".join(r[h] for h in headers))


if __name__ == "__main__":
    main()
