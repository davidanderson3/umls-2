from __future__ import annotations
import json
import subprocess
from pathlib import Path
from typing import Any, Dict


def run_metamaplite(text: str, metamaplite_dir: str | None = None) -> Dict[str, Any]:
    """Run MetaMapLite on *text* and return the parsed JSON output."""
    meta_dir = Path(metamaplite_dir) if metamaplite_dir else Path()
    jar = meta_dir / "metamaplite-1.0.jar"
    cmd = ["java", "-jar", str(jar), text]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        raise RuntimeError(f"MetaMapLite failed: {result.stderr}")
    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError as e:
        raise RuntimeError("Invalid JSON from MetaMapLite") from e

