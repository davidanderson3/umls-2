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


def scan_files(file_info, directory):
    values = defaultdict(set)
    for fname, columns in file_info:
        path = os.path.join(directory, fname)
        if not os.path.isfile(path):
            continue
        with open(path, 'r', encoding='utf-8', errors='ignore') as f:
            reader = csv.reader(f, delimiter='|')
            for row in reader:
                if row and row[-1] == '':
                    row = row[:-1]
                for col, val in zip(columns, row):
                    values[col].add(val)
    return values


def write_mrdoc(values, out_path):
    with open(out_path, 'w', encoding='utf-8') as f:
        for col in sorted(values.keys()):
            for val in sorted(values[col]):
                line = [col, val, 'observed', f'Observed value for {col}']
                f.write('|'.join(line) + '|' + '\n')


def main():
    # Increase the CSV field size limit to handle very large entries
    csv.field_size_limit(sys.maxsize)
    parser = argparse.ArgumentParser(description='Regenerate MRDOC from MRFILES.')
    parser.add_argument('--data-dir', default='Data', help='Directory containing RRF files')
    parser.add_argument('--mrfiles', default='Data/MRFILES.RRF', help='Path to MRFILES.RRF')
    parser.add_argument('--output', default='Data/MRDOC.RRF', help='Path for generated MRDOC')
    args = parser.parse_args()

    file_info = read_mrfiles(args.mrfiles)
    values = scan_files(file_info, args.data_dir)
    write_mrdoc(values, args.output)


if __name__ == '__main__':
    main()
