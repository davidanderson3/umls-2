import subprocess
import json
from pathlib import Path

def test_prettyprint_output(tmp_path):
    script = Path(__file__).resolve().parents[1] / 'nlp' / 'prettyprint.py'
    sample = [
        {
            "matchedtext": "heart attack",
            "start": 0,
            "length": 12,
            "evlist": [
                {
                    "score": 0,
                    "conceptinfo": {
                        "cui": "C0027051",
                        "preferredname": "Myocardial Infarction",
                        "semantictypes": ["dsyn"]
                    }
                }
            ]
        }
    ]
    input_json = json.dumps(sample).encode()
    result = subprocess.run(['python3', str(script)], input=input_json, capture_output=True)
    assert result.returncode == 0
    output = result.stdout.decode()
    assert 'Myocardial Infarction' in output
