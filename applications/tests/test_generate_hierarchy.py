import sys
import os
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from generate_hierarchy import parse_mrconso, parse_mrrel, build_tree


def write_temp_file(path: Path, lines: list[str]):
    path.write_text("\n".join(lines) + "\n")


def test_cycle_resolution(tmp_path: Path):
    conso = tmp_path / "MRCONSO.RRF"
    rel = tmp_path / "MRREL.RRF"
    write_temp_file(
        conso,
        [
            "C1|ENG|||||||SAUI1|SC1|SD1|SAB|TTY|CODE1|Concept1|0|N|0|",
            "C2|ENG|||||||SAUI2|SC2|SD2|SAB|TTY|CODE2|Concept2|0|N|0|",
            "C3|ENG|||||||SAUI3|SC3|SD3|SAB|TTY|CODE3|Concept3|0|N|0|",
        ],
    )
    write_temp_file(
        rel,
        [
            "C1|A1|S|PAR|C2|A2|S||R1||SAB|||N|0|",
            "C2|A2|S|PAR|C3|A3|S||R2||SAB|||N|0|",
            "C3|A3|S|PAR|C1|A1|S||R3||SAB|||N|0|",
        ],
    )

    names = parse_mrconso(str(conso))
    edges = parse_mrrel(str(rel))
    tree = build_tree("C1", edges, names)
    serialized = json.dumps(tree)
    assert "cycle" in serialized
    assert tree["CUI"] == "C1"
