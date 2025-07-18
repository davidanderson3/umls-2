import csv
import json
import argparse
from pathlib import Path


def load_preferred_names(conso_path: Path) -> dict[str, str]:
    """Return a mapping of CUI -> preferred English name from MRCONSO."""
    names: dict[str, tuple[str, bool]] = {}
    with conso_path.open('r', encoding='utf-8', errors='ignore') as f:
        reader = csv.reader(f, delimiter='|')
        for row in reader:
            if row and row[-1] == '':
                row = row[:-1]
            if len(row) < 17:
                continue
            cui = row[0]
            lat = row[1]
            ispref = row[6]
            string = row[14]
            suppress = row[16]
            if lat != 'ENG' or suppress != 'N':
                continue
            current = names.get(cui)
            if current is None or (ispref == 'Y' and not current[1]):
                names[cui] = (string, ispref == 'Y')
    return {k: v[0] for k, v in names.items()}


def relationships_to_json(rel_path: Path, names: dict[str, str], out_path: Path) -> None:
    """Write a JSON array with relationship info and preferred names."""
    data = []
    with rel_path.open('r', encoding='utf-8', errors='ignore') as f:
        reader = csv.reader(f, delimiter='|')
        for row in reader:
            if row and row[-1] == '':
                row = row[:-1]
            if len(row) < 12:
                continue
            cui1 = row[0]
            cui2 = row[4]
            rel = row[3]
            rela = row[7]
            sab = row[10]
            data.append({
                "CUI1": cui1,
                "CUI2": cui2,
                "REL": rel,
                "RELA": rela,
                "SAB": sab,
                "CUI1_name": names.get(cui1),
                "CUI2_name": names.get(cui2),
            })
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with out_path.open('w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate JSON from MRREL with preferred names")
    parser.add_argument('--data-dir', default='Data', help='Directory containing MRCONSO.RRF and MRREL.RRF')
    parser.add_argument('--output', default='data/relationships/relationships.json', help='Output JSON file path')
    args = parser.parse_args()
    data_dir = Path(args.data_dir)
    conso_path = data_dir / 'MRCONSO.RRF'
    rel_path = data_dir / 'MRREL.RRF'
    names = load_preferred_names(conso_path)
    relationships_to_json(rel_path, names, Path(args.output))


if __name__ == '__main__':
    main()
