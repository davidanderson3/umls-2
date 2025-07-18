from flask import Flask, jsonify, request
from .metamaplite import run_metamaplite


def create_app(metamaplite_dir: str | None = None) -> Flask:
    app = Flask(__name__)

    @app.route("/annotate", methods=["POST"])
    def annotate():
        data = request.get_json() or {}
        text = data.get("text", "")
        result = run_metamaplite(text, metamaplite_dir=metamaplite_dir)
        return jsonify(result)

    return app


def main() -> None:
    import argparse

    parser = argparse.ArgumentParser(description="MetaMapLite NLP API")
    parser.add_argument("--host", default="0.0.0.0")
    parser.add_argument("--port", type=int, default=5000)
    parser.add_argument("--metamap-dir")
    args = parser.parse_args()

    app = create_app(args.metamap_dir)
    app.run(host=args.host, port=args.port)


if __name__ == "__main__":
    main()
