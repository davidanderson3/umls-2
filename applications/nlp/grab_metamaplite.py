#!/usr/bin/env python3
"""Download MetaMapLite from GitHub."""

from __future__ import annotations
import argparse
import subprocess
from pathlib import Path

REPO_URL = "https://github.com/lhncbc/MetaMapLite.git"


def grab(destination: str = "MetaMapLite") -> Path:
    """Clone MetaMapLite repository into *destination* and return the path."""
    dest = Path(destination)
    if dest.exists() and any(dest.iterdir()):
        raise SystemExit(f"{dest} already exists and is not empty")
    subprocess.run(["git", "clone", "--depth", "1", REPO_URL, str(dest)], check=True)
    return dest


def main() -> None:
    parser = argparse.ArgumentParser(description="Grab MetaMapLite from GitHub")
    parser.add_argument("destination", nargs="?", default="MetaMapLite")
    args = parser.parse_args()
    grab(args.destination)


if __name__ == "__main__":
    main()
