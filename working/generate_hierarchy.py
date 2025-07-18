from __future__ import annotations
import argparse
import csv
import json
from collections import defaultdict
from pathlib import Path
from typing import Dict, List, Set


def parse_mrconso(path: str) -> Dict[str, str]:
    """Return a mapping of CUI -> preferred English string."""
    names: Dict[str, str] = {}
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        reader = csv.reader(f, delimiter="|")
        for row in reader:
            if row and row[-1] == "":
                row = row[:-1]
            if len(row) < 15:
                continue
            cui, lat = row[0], row[1]
            string = row[14]
            if lat == "ENG" and cui not in names:
                names[cui] = string
    return names


def parse_mrrel(path: str) -> Dict[str, Set[str]]:
    """Return mapping of parent CUI -> set of child CUIs."""
    edges: Dict[str, Set[str]] = defaultdict(set)
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        reader = csv.reader(f, delimiter="|")
        for row in reader:
            if row and row[-1] == "":
                row = row[:-1]
            if len(row) < 4:
                continue
            cui1, rel, cui2 = row[0], row[3], row[4]
            if rel == "CHD":
                edges[cui1].add(cui2)
            elif rel == "PAR":
                edges[cui2].add(cui1)
    return edges


def build_tree(root: str, edges: Dict[str, Set[str]], names: Dict[str, str]) -> Dict:
    visited: Set[str] = set()
    path: Set[str] = set()

    def dfs(node: str) -> Dict:
        if node in path:
            # cycle detected; skip this branch
            return {"CUI": node, "name": names.get(node, node), "cycle": True}
        if node in visited:
            return {"CUI": node, "name": names.get(node, node)}
        visited.add(node)
        path.add(node)
        children = [dfs(ch) for ch in edges.get(node, [])]
        path.remove(node)
        return {"CUI": node, "name": names.get(node, node), "children": children}

    return dfs(root)


def write_html(tree: Dict, out_path: str) -> None:
    template = f"""
<!DOCTYPE html>
<html>
<head>
<meta charset='utf-8'>
<title>UMLS Hierarchy</title>
<style>
ul {{ list-style: none; }}
li {{ margin-left: 1em; }}
</style>
</head>
<body>
<div id="tree"></div>
<script>
const data = {json.dumps(tree)};
function render(node) {{
  const li = document.createElement('li');
  li.textContent = node.name + ' (' + node.CUI + (node.cycle ? ' - cycle' : '') + ')';
  if (node.children && node.children.length) {{
    const ul = document.createElement('ul');
    for (const child of node.children) {{
      ul.appendChild(render(child));
    }}
    li.appendChild(ul);
  }}
  return li;
}}
const container = document.getElementById('tree');
const ul = document.createElement('ul');
ul.appendChild(render(data));
container.appendChild(ul);
</script>
</body>
</html>
"""
    Path(out_path).write_text(template, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate browsable UMLS hierarchy")
    parser.add_argument("mrrel", help="Path to MRREL.RRF")
    parser.add_argument("mrconso", help="Path to MRCONSO.RRF")
    parser.add_argument("--root", help="Root CUI", required=True)
    parser.add_argument("--html", help="Output HTML file")
    args = parser.parse_args()

    names = parse_mrconso(args.mrconso)
    edges = parse_mrrel(args.mrrel)
    tree = build_tree(args.root, edges, names)

    if args.html:
        write_html(tree, args.html)
    else:
        print(json.dumps(tree, indent=2))


if __name__ == "__main__":
    main()
