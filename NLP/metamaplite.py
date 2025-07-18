import json
import os
import subprocess
from pathlib import Path


def run_metamaplite(text: str, metamaplite_dir: str | None = None) -> dict:
    """Run MetaMapLite on the given text and return JSON output."""
    metamaplite_dir = metamaplite_dir or os.environ.get("METAMAPLITE_DIR", ".")
    jar = Path(metamaplite_dir) / "metamaplite-1.0.jar"
    cmd = ["java", "-jar", str(jar), "--inputtext", text, "--outputformat", "json"]
    result = subprocess.run(cmd, capture_output=True, text=True, check=True)
    return json.loads(result.stdout)
