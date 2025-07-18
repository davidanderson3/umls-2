import json
from pathlib import Path

from generate_relationship_json import load_preferred_names, relationships_to_json


MRCONSO_SAMPLE = """\
C0000001|ENG|P|L1|PF|S1|Y|A1|SAUI1|SCUI1|SDUI1|SAB1|TTY|CODE1|Heart Attack|SRL|N|
C0000002|ENG|P|L2|PF|S2|N|A2|SAUI2|SCUI2|SDUI2|SAB1|TTY|CODE2|Myocardial Infarction|SRL|N|
C0000003|ENG|P|L3|PF|S3|Y|A3|SAUI3|SCUI3|SDUI3|SAB2|TTY|CODE3|Hypertension|SRL|N|
"""

MRREL_SAMPLE = """\
C0000001|A1|CUI|CHD|C0000003|A3|CUI|revised|RUI1||SAB1|SL||1|N|0|
C0000001|A1|CUI|SY|C0000002|A2|CUI|synonym|RUI2||SAB1|SL||1|N|0|
"""


def test_relationship_json(tmp_path: Path):
    data_dir = tmp_path
    (data_dir / "MRCONSO.RRF").write_text(MRCONSO_SAMPLE)
    (data_dir / "MRREL.RRF").write_text(MRREL_SAMPLE)

    names = load_preferred_names(data_dir / "MRCONSO.RRF")
    assert names["C0000001"] == "Heart Attack"
    assert names["C0000002"] == "Myocardial Infarction"
    assert names["C0000003"] == "Hypertension"

    out_path = data_dir / "out.json"
    relationships_to_json(data_dir / "MRREL.RRF", names, out_path)

    data = json.loads(out_path.read_text())
    assert data == [
        {
            "CUI1": "C0000001",
            "CUI2": "C0000003",
            "REL": "CHD",
            "RELA": "revised",
            "SAB": "SAB1",
            "CUI1_name": "Heart Attack",
            "CUI2_name": "Hypertension",
        },
        {
            "CUI1": "C0000001",
            "CUI2": "C0000002",
            "REL": "SY",
            "RELA": "synonym",
            "SAB": "SAB1",
            "CUI1_name": "Heart Attack",
            "CUI2_name": "Myocardial Infarction",
        },
    ]
