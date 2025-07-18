import argparse
import json
from .metamaplite import run_metamaplite


def main() -> None:
    parser = argparse.ArgumentParser(description="Annotate text with MetaMapLite")
    parser.add_argument("text", help="Text to annotate")
    parser.add_argument("--metamap-dir")
    args = parser.parse_args()

    result = run_metamaplite(args.text, metamaplite_dir=args.metamap_dir)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
