from __future__ import annotations

import argparse
import csv
import json
from collections import defaultdict
from pathlib import Path
from typing import Dict, List, Set


def parse_mrconso(path: str) -> Dict[str, List[str]]:
    """Return mapping of CUI -> sorted list of unique English names."""
    names: Dict[str, Set[str]] = defaultdict(set)
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        reader = csv.reader(f, delimiter="|")
        for row in reader:
            if row and row[-1] == "":
                row = row[:-1]
            if len(row) < 15:
                continue
            cui = row[0]
            lat = row[1]
            string = row[14]
            if lat == "ENG":
                names[cui].add(string)
    return {cui: sorted(list(n)) for cui, n in names.items()}


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate a JSON file of CUIs mapped to unique English names"
    )
    parser.add_argument(
        "mrconso",
        nargs="?",
        default="/data/MRCONSO.RRF",
        help="Path to MRCONSO.RRF",
    )
    parser.add_argument(
        "--output",
        default=Path("data/names/cui_unique_names.json"),
        help="Output JSON file",
    )
    args = parser.parse_args()

    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    mapping = parse_mrconso(args.mrconso)

    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(mapping, f, indent=2, ensure_ascii=False)

    print(f"Wrote {len(mapping)} CUIs to {output_path}")


if __name__ == "__main__":
    main()
