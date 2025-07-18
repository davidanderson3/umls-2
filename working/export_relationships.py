from __future__ import annotations
import argparse
import csv
import json
from pathlib import Path
from typing import Dict, List


def parse_mrconso(path: str) -> Dict[str, str]:
    """Return mapping of CUI -> preferred English name."""
    names: Dict[str, str] = {}
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        reader = csv.reader(f, delimiter="|")
        for row in reader:
            if row and row[-1] == "":
                row = row[:-1]
            if len(row) < 15:
                continue
            cui, lat, ispref, string = row[0], row[1], row[6], row[14]
            if lat != "ENG":
                continue
            if cui not in names or ispref == "Y":
                names[cui] = string
    return names


def parse_mrrel(path: str, names: Dict[str, str]) -> List[Dict[str, str]]:
    """Return list of relationship dictionaries from MRREL."""
    relationships: List[Dict[str, str]] = []
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        reader = csv.reader(f, delimiter="|")
        for row in reader:
            if row and row[-1] == "":
                row = row[:-1]
            if len(row) < 11:
                continue
            cui1, rel, cui2 = row[0], row[3], row[4]
            rela = row[7] if len(row) > 7 else ""
            sab = row[10] if len(row) > 10 else ""
            relationships.append(
                {
                    "CUI1": cui1,
                    "CUI1_name": names.get(cui1, ""),
                    "REL": rel,
                    "RELA": rela,
                    "SAB": sab,
                    "CUI2": cui2,
                    "CUI2_name": names.get(cui2, ""),
                }
            )
    return relationships


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate JSON representation of MRREL relationships")
    parser.add_argument("mrrel", help="Path to MRREL.RRF")
    parser.add_argument("mrconso", help="Path to MRCONSO.RRF")
    parser.add_argument(
        "--output",
        default=Path("data/relationships/relationships.json"),
        help="Output JSON file",
    )
    args = parser.parse_args()

    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    names = parse_mrconso(args.mrconso)
    rels = parse_mrrel(args.mrrel, names)

    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(rels, f, indent=2)

    print(f"Wrote {len(rels)} relationships to {output_path}")


if __name__ == "__main__":
    main()
