import json
import subprocess
from pathlib import Path
from typing import Optional, Dict


def run_metamaplite(text: str, metamaplite_dir: Optional[str] = None) -> Dict:
    """Run MetaMapLite on *text* and return parsed JSON output."""
    jar_name = "metamaplite-1.0.jar"
    jar_path = Path(metamaplite_dir or '.') / jar_name
    cmd = ["java", "-jar", str(jar_path), text]
    result = subprocess.run(cmd, capture_output=True, text=True)
    result.check_returncode()
    return json.loads(result.stdout or '{}')
