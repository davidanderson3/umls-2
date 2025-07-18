import csv
import json
import os
from collections import defaultdict

# Paths to RRF files
DATA_DIR = 'Data'
MRCONSO = os.path.join(DATA_DIR, 'MRCONSO.RRF')
MRREL = os.path.join(DATA_DIR, 'MRREL.RRF')

OUTPUT_DIR = os.path.join('data', 'relationships')
OUTPUT_JSON = os.path.join(OUTPUT_DIR, 'relationships.json')


def load_preferred_names(path: str) -> dict:
    """Return a mapping of CUI -> preferred English name."""
    pref = {}
    if not os.path.isfile(path):
        return pref
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        reader = csv.reader(f, delimiter='|')
        for row in reader:
            if not row:
                continue
            if row[-1] == '':
                row = row[:-1]
            cui = row[0]
            lat = row[1]
            ispref = row[6]
            name = row[14]
            if cui not in pref:
                if lat == 'ENG' and ispref == 'Y':
                    pref[cui] = name
            # fall back to first english term if preferred not found
            if cui not in pref and lat == 'ENG':
                pref[cui] = name
            # final fall back to any term
            if cui not in pref:
                pref[cui] = name
    return pref


def relationships_to_json(mrrel: str, pref_names: dict, out_path: str) -> None:
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(mrrel, 'r', encoding='utf-8', errors='ignore') as fin, open(
        out_path, 'w', encoding='utf-8'
    ) as fout:
        reader = csv.reader(fin, delimiter='|')
        relationships = []
        for row in reader:
            if not row:
                continue
            if row[-1] == '':
                row = row[:-1]
            cui1, aui1, stype1, rel, cui2, aui2, stype2, rela, rui, srui, sab, sl, rg, dir_, suppress, cvf = row
            relationships.append(
                {
                    'cui1': cui1,
                    'name1': pref_names.get(cui1, ''),
                    'rel': rel,
                    'rela': rela,
                    'cui2': cui2,
                    'name2': pref_names.get(cui2, ''),
                    'sab': sab,
                }
            )
        json.dump(relationships, fout, ensure_ascii=False, indent=2)


def main() -> None:
    pref_names = load_preferred_names(MRCONSO)
    relationships_to_json(MRREL, pref_names, OUTPUT_JSON)


if __name__ == '__main__':
    main()
