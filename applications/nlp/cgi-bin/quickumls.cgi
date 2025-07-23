#!/usr/bin/env python3
import os, sys, json, urllib.parse

try:
    from quickumls import QuickUMLS
except Exception as e:
    print("Status: 500 Internal Server Error\n")
    print("Content-Type: text/plain\n")
    print()
    print("QuickUMLS not installed: %s" % e)
    sys.exit(0)

def main():
    length = int(os.environ.get('CONTENT_LENGTH', '0'))
    body = sys.stdin.read(length)
    params = urllib.parse.parse_qs(body)
    text = params.get('text', [''])[0]
    debug = 'debug' in params
    base = os.path.join(os.path.dirname(__file__), '..')
    quickumls_dir = os.environ.get('QUICKUMLS_DIR', os.path.join(base, 'quickumls'))
    matcher = QuickUMLS(quickumls_dir, best_match=True)
    matches = matcher.match(text, best_match=True)
    anns = []
    for span in matches:
        for m in span:
            anns.append({
                'start': m.get('start'),
                'end': m.get('end'),
                'ngram': m.get('ngram'),
                'term': m.get('term'),
                'cui': m.get('cui'),
                'similarity': m.get('similarity'),
                'semtypes': m.get('semtypes', [])
            })
    if debug:
        print('Content-Type: text/plain')
    else:
        print('Content-Type: application/json')
    print()
    print(json.dumps(anns))

if __name__ == '__main__':
    main()
