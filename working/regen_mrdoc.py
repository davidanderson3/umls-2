import csv
import sys
import os
import argparse
from collections import defaultdict


def read_mrfiles(path):
    files = []
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        reader = csv.reader(f, delimiter='|')
        for row in reader:
            if row and row[-1] == '':
                row = row[:-1]
            if len(row) >= 3:
                fname = row[0]
                columns = [c.strip() for c in row[2].split(',') if c]
                files.append((fname, columns))
    return files


def parse_mrdoc(path):
    """Return all MRDOC rows and the values they describe."""
    rows = []
    values = defaultdict(set)
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        reader = csv.reader(f, delimiter="|")
        for row in reader:
            if row and row[-1] == "":
                row = row[:-1]
            if len(row) >= 4:
                col, val = row[0], row[1]
                rows.append(row)
                values[col].add(val)
    return rows, values


def scan_files(file_info, needed, directory):
    """Return which (column, value) pairs actually occur in data files."""
    remaining = {c: set(v) for c, v in needed.items()}
    found = defaultdict(set)
    for fname, columns in file_info:
        path = os.path.join(directory, fname)
        if not remaining or not os.path.isfile(path):
            continue
        with open(path, "r", encoding="utf-8", errors="ignore") as f:
            reader = csv.reader(f, delimiter="|")
            for row in reader:
                if row and row[-1] == "":
                    row = row[:-1]
                for col, val in zip(columns, row):
                    if col in remaining and val in remaining[col]:
                        found[col].add(val)
                        remaining[col].discard(val)
                        if not remaining[col]:
                            del remaining[col]
                if not remaining:
                    return found
    return found


def write_subset(rows, used, out_path):
    with open(out_path, "w", encoding="utf-8") as f:
        writer = csv.writer(f, delimiter="|", lineterminator="\n")
        for row in rows:
            col, val = row[0], row[1]
            if val in used.get(col, set()):
                writer.writerow(row + [""])


def main():
    # Increase the CSV field size limit to handle very large entries
    csv.field_size_limit(sys.maxsize)
    parser = argparse.ArgumentParser(description='Regenerate MRDOC from MRFILES.')
    parser.add_argument('--data-dir', default='Data', help='Directory containing RRF files')
    parser.add_argument('--mrfiles', default='Data/MRFILES.RRF', help='Path to MRFILES.RRF')
    parser.add_argument('--mrdoc', default='Data/MRDOC.RRF', help='Path to original MRDOC')
    parser.add_argument('--output', default='Data/MRDOC.RRF', help='Path for generated MRDOC')
    args = parser.parse_args()

    file_info = read_mrfiles(args.mrfiles)
    rows, needed = parse_mrdoc(args.mrdoc)
    used = scan_files(file_info, needed, args.data_dir)
    write_subset(rows, used, args.output)


if __name__ == '__main__':
    main()
