import os
import csv
import json
import re

SQL_FILE = os.path.join('load_scripts', 'mysql_tables.sql')
RRF_FILES = [
    'MRAUI.RRF',
    'MRCONSO.RRF',
    'MRDEF.RRF',
    'MRFILES.RRF',
    'MRRANK.RRF',
    'MRSAB.RRF',
    'MRSTY.RRF',
    'MRXNW_ENG.RRF',
    'MRCOLS.RRF',
    'MRCUI.RRF',
    'MRDOC.RRF',
    'MRHIER.RRF',
    'MRREL.RRF',
    'MRSAT.RRF',
    'MRXNS_ENG.RRF'
]

OUTPUT_FILE = 'field_review_results.json'


def parse_table_columns(sql_path):
    with open(sql_path, 'r', encoding='utf-8') as f:
        sql = f.read()
    pattern = re.compile(r"CREATE TABLE\s+(\w+)\s*\((.*?)\)\s*CHARACTER SET", re.DOTALL)
    tables = {}
    for match in pattern.finditer(sql):
        table = match.group(1)
        block = match.group(2)
        columns = []
        for line in block.strip().splitlines():
            line = line.strip()
            if not line or line.startswith('DROP '):
                continue
            # remove trailing comma
            line = line.rstrip(',')
            col_match = re.match(r'([A-Z0-9_]+)', line)
            if col_match:
                columns.append(col_match.group(1))
        tables[table] = columns
    return tables


def sample_rows(file_path, num=5):
    samples = []
    if not os.path.isfile(file_path):
        return samples
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        reader = csv.reader(f, delimiter='|')
        for _, row in zip(range(num), reader):
            if row and row[-1] == '':
                row = row[:-1]
            samples.append(row)
    return samples


def review_file(rrf_file, columns):
    print(f"\nReviewing {rrf_file}")
    sample = sample_rows(rrf_file, num=3)
    results = {}
    for idx, col in enumerate(columns):
        examples = [row[idx] if idx < len(row) else '' for row in sample]
        print(f"\nColumn: {col}")
        if examples:
            for ex in examples:
                print(f"  example: {ex}")
        else:
            print("  (no examples found)")
        ans = input("Mark for deletion? [y/N]: ").strip().lower()
        results[col] = ans == 'y'
    return results


def main():
    tables = parse_table_columns(SQL_FILE)
    all_results = {}
    for rrf in RRF_FILES:
        table = rrf.split('.')[0]
        cols = tables.get(table)
        if not cols:
            print(f"Warning: table definition for {table} not found.")
            continue
        res = review_file(rrf, cols)
        all_results[rrf] = res
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(all_results, f, indent=2)
    print(f"\nResults saved to {OUTPUT_FILE}")


if __name__ == '__main__':
    main()
