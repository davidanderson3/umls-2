#!/usr/bin/env python3
"""Interactive tool for evaluating fields in UMLS RRF files.

This script reads UMLS `.ctl` files to obtain column names for the
corresponding `.RRF` data files.  It then loads the data and presents
each field to the user with a short sample of values.  For every field
you can decide whether to keep it.  Decisions are stored in a JSON file
so the evaluation can be resumed later.

Additional RRF files may be joined to the main file using the `--join`
option in order to give more context when inspecting values.  Join
specifications have the form `RRF_PATH:CTL_PATH:KEY`.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Dict, List

import pandas as pd


def parse_ctl(path: Path) -> List[str]:
    """Return a list of field names parsed from a .ctl file."""
    text = path.read_text()
    start = text.find("(")
    end = text.rfind(")")
    if start == -1 or end == -1 or end <= start:
        raise ValueError(f"Unable to parse columns from {path}")
    lines = text[start + 1 : end].splitlines()
    fields = []
    for line in lines:
        line = line.strip().strip(",")
        if not line:
            continue
        field = line.split()[0]
        fields.append(field)
    return fields


def read_rrf(path: Path, fields: List[str]) -> pd.DataFrame:
    """Load a UMLS RRF file with the provided column names."""
    records = []
    with path.open(encoding="utf-8") as f:
        for line in f:
            parts = line.rstrip("\n").split("|")
            if parts and parts[-1] == "":
                parts = parts[:-1]
            records.append(parts)
    return pd.DataFrame(records, columns=fields)


def join_files(df: pd.DataFrame, joins: List[str]) -> pd.DataFrame:
    """Join additional RRF files using specs from --join."""
    for spec in joins:
        rrf_path, ctl_path, key = spec.split(":")
        join_fields = parse_ctl(Path(ctl_path))
        join_df = read_rrf(Path(rrf_path), join_fields)
        df = df.merge(join_df, on=key, how="left", suffixes=("", f"_{Path(rrf_path).stem}"))
    return df


def interactive_eval(df: pd.DataFrame, previous: Dict[str, bool]) -> Dict[str, bool]:
    """Prompt the user about keeping each column in the data frame."""
    decisions = previous.copy()
    for col in df.columns:
        if col in decisions:
            continue
        print("\n" + "-" * 40)
        print(f"Field: {col}")
        print(df[col].head())
        ans = input("Keep this field? [y/n] ").strip().lower()
        decisions[col] = ans.startswith("y")
    return decisions


def main() -> None:
    parser = argparse.ArgumentParser(description="Interactively evaluate fields in a UMLS file")
    parser.add_argument("rrf", help="Path to main RRF file")
    parser.add_argument("ctl", help="Path to corresponding .ctl file")
    parser.add_argument("--save", default="choices.json", help="Where to store decisions")
    parser.add_argument("--join", action="append", default=[], help="Join specification RRF:CTL:KEY")
    args = parser.parse_args()

    fields = parse_ctl(Path(args.ctl))
    df = read_rrf(Path(args.rrf), fields)
    if args.join:
        df = join_files(df, args.join)

    if Path(args.save).exists():
        previous = json.loads(Path(args.save).read_text())
    else:
        previous = {}

    decisions = interactive_eval(df, previous)
    Path(args.save).write_text(json.dumps(decisions, indent=2))
    print(f"Decisions saved to {args.save}")


if __name__ == "__main__":
    main()
