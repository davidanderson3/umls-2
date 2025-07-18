from flask import Flask, jsonify, request
from NLP.metamaplite import run_metamaplite


def create_app(metamaplite_dir: str | None = None) -> Flask:
    app = Flask(__name__)

    @app.route("/annotate", methods=["POST"])
    def annotate():
        data = request.get_json() or {}
        text = data.get("text", "")
        result = run_metamaplite(text, metamaplite_dir=metamaplite_dir)
        return jsonify(result)

    return app
