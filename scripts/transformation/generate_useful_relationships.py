from __future__ import annotations
import argparse
import csv
import json
from pathlib import Path
from typing import Dict, List, Tuple


def parse_mrconso(path: str) -> Tuple[Dict[str, str], Dict[str, str]]:
    """Return mappings of AUI -> label and CUI -> preferred label."""
    aui_names: Dict[str, str] = {}
    cui_pref: Dict[str, str] = {}
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        reader = csv.reader(f, delimiter="|")
        for row in reader:
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
    return aui_names, cui_pref


def parse_mrrel(
    path: str, aui_names: Dict[str, str], cui_pref: Dict[str, str]
) -> List[Dict[str, str]]:
    """Return human-readable relationship records from MRREL."""
    records: List[Dict[str, str]] = []
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        reader = csv.reader(f, delimiter="|")
        for row in reader:
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
            label1 = aui_names.get(aui1) or cui_pref.get(cui1, "")
            label2 = aui_names.get(aui2) or cui_pref.get(cui2, "")
            records.append(
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
    return records


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate a useful JSON relationships file"
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
