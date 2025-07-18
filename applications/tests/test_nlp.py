import sys, os
os_sys_path = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if os_sys_path not in sys.path:
    sys.path.insert(0, os_sys_path)
import json
from unittest.mock import patch

from NLP.metamaplite import run_metamaplite
from NLP.api import create_app


def test_run_metamaplite_calls_java(tmp_path):
    jar = tmp_path / "metamaplite-1.0.jar"
    jar.write_text("")
    with patch("subprocess.run") as mock_run:
        mock_run.return_value.stdout = '{"result":"ok"}'
        mock_run.return_value.returncode = 0
        result = run_metamaplite("sample", metamaplite_dir=str(tmp_path))
        mock_run.assert_called_once()
        cmd = mock_run.call_args[0][0]
        assert "java" in cmd[0]
        assert str(jar) in cmd
        assert result == {"result": "ok"}


def test_api_annotation_returns_json():
    app = create_app()
    with app.test_client() as client, patch("NLP.api.run_metamaplite") as mock_run:
        mock_run.return_value = {"utterances": []}
        resp = client.post("/annotate", json={"text": "hi"})
        assert resp.status_code == 200
        assert resp.get_json() == {"utterances": []}
        mock_run.assert_called_once_with("hi", metamaplite_dir=None)
