from __future__ import annotations
import argparse
import csv
import json
import sys
from pathlib import Path
from collections import defaultdict
from typing import Any, Dict, List, Tuple


def parse_mrconso(path: str) -> Tuple[Dict[str, str], Dict[str, str]]:
    """Return mappings of AUI -> label and CUI -> preferred label."""
    aui_names: Dict[str, str] = {}
    cui_pref: Dict[str, str] = {}
    csv.field_size_limit(sys.maxsize)
    print("Parsing MRCONSO.RRF...", flush=True)
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        reader = csv.reader(f, delimiter="|")
        for i, row in enumerate(reader, start=1):
            if row and row[-1] == "":
                row = row[:-1]
            if len(row) < 15:
                continue
            cui = row[0]
            lat = row[1]
            ts = row[2]
            stt = row[4]
            ispref = row[6]
            aui = row[7]
            string = row[14]
            if aui and aui not in aui_names:
                aui_names[aui] = string
            if (
                lat == "ENG"
                and ts == "P"
                and stt == "PF"
                and ispref == "Y"
                and cui not in cui_pref
            ):
                cui_pref[cui] = string
            if i % 500000 == 0:
                print(f"  processed {i} MRCONSO rows", flush=True)
    print(f"Finished MRCONSO: {len(aui_names)} AUI names, {len(cui_pref)} CUI prefs", flush=True)
    return aui_names, cui_pref


def parse_mrrel(
    path: str, aui_names: Dict[str, str], cui_pref: Dict[str, str]
) -> List[Dict[str, Any]]:
    """Return aggregated relationship records from MRREL."""

    pairs: Dict[Tuple[str, str], List[Dict[str, str]]] = defaultdict(list)
    csv.field_size_limit(sys.maxsize)
    print("Parsing MRREL.RRF...", flush=True)
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        reader = csv.reader(f, delimiter="|")
        for i, row in enumerate(reader, start=1):
            if row and row[-1] == "":
                row = row[:-1]
            if len(row) < 6:
                continue
            cui1 = row[0]
            aui1 = row[1]
            rel = row[3]
            cui2 = row[4]
            aui2 = row[5]
            rela = row[7] if len(row) > 7 else ""
            sab = row[10] if len(row) > 10 else ""

            if cui1 == cui2:
                # skip self-referential relationships
                continue
            if sab.startswith("MDR"):
                # skip MedDRA translations
                continue

            label1 = aui_names.get(aui1) or cui_pref.get(cui1, "")
            label2 = aui_names.get(aui2) or cui_pref.get(cui2, "")

            key = tuple(sorted([cui1, cui2]))
            pairs[key].append(
                {
                    "source_cui": cui1,
                    "source_label": label1,
                    "rel": rel,
                    "rela": rela,
                    "sab": sab,
                    "target_cui": cui2,
                    "target_label": label2,
                }
            )

            if i % 500000 == 0:
                print(f"  processed {i} MRREL rows", flush=True)

    print(f"Finished MRREL: {sum(len(v) for v in pairs.values())} rows", flush=True)

    records: List[Dict[str, Any]] = []
    for (cui_a, cui_b), rels in pairs.items():
        records.append(
            {
                "cui1": cui_a,
                "cui1_label": cui_pref.get(cui_a, ""),
                "cui2": cui_b,
                "cui2_label": cui_pref.get(cui_b, ""),
                "relationships": rels,
            }
        )

    return records


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate a JSON file of CUI pairs with their relationships"
    )
    parser.add_argument(
        "data_dir",
        nargs="?",
        default="Data",
        help="Directory containing MRREL.RRF and MRCONSO.RRF",
    )
    parser.add_argument(
        "--output",
        default=Path("data/relationships/useful_relationships.json"),
        help="Output JSON file",
    )
    args = parser.parse_args()

    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    data_dir = Path(args.data_dir)
    mrconso_path = data_dir / "MRCONSO.RRF"
    mrrel_path = data_dir / "MRREL.RRF"

    aui_names, cui_pref = parse_mrconso(str(mrconso_path))
    records = parse_mrrel(str(mrrel_path), aui_names, cui_pref)

    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(records, f, indent=2, ensure_ascii=False)

    print(f"Wrote {len(records)} relationships to {output_path}")


if __name__ == "__main__":
    main()
