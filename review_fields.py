import os
import csv
import json
import re
from flask import Flask, render_template_string, request

SQL_FILE = os.path.join('load_scripts', 'mysql_tables.sql')
RRF_FILES = [
    'MRAUI.RRF',
    'MRCONSO.RRF',
    'MRDEF.RRF',
    'MRFILES.RRF',
    'MRRANK.RRF',
    'MRSAB.RRF',
    'MRSTY.RRF',
    'MRXNW_ENG.RRF',
    'MRCOLS.RRF',
    'MRCUI.RRF',
    'MRDOC.RRF',
    'MRHIER.RRF',
    'MRREL.RRF',
    'MRSAT.RRF',
    'MRXNS_ENG.RRF'
]

OUTPUT_FILE = 'field_review_results.json'


def parse_table_columns(sql_path):
    with open(sql_path, 'r', encoding='utf-8') as f:
        sql = f.read()
    pattern = re.compile(r"CREATE TABLE\s+(\w+)\s*\((.*?)\)\s*CHARACTER SET", re.DOTALL)
    tables = {}
    for match in pattern.finditer(sql):
        table = match.group(1)
        block = match.group(2)
        columns = []
        for line in block.strip().splitlines():
            line = line.strip()
            if not line or line.startswith('DROP '):
                continue
            # remove trailing comma
            line = line.rstrip(',')
            col_match = re.match(r'([A-Z0-9_]+)', line)
            if col_match:
                columns.append(col_match.group(1))
        tables[table] = columns
    return tables


def sample_rows(file_path, num=5):
    samples = []
    if not os.path.isfile(file_path):
        return samples
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        reader = csv.reader(f, delimiter='|')
        for _, row in zip(range(num), reader):
            if row and row[-1] == '':
                row = row[:-1]
            samples.append(row)
    return samples


MAX_EXAMPLES = 3


def load_previous():
    if os.path.isfile(OUTPUT_FILE):
        with open(OUTPUT_FILE, 'r', encoding='utf-8') as f:
            return json.load(f)
    return {}


tables = parse_table_columns(SQL_FILE)
tables_by_rrf = {rrf: tables.get(rrf.split('.')[0], []) for rrf in RRF_FILES}
samples = {rrf: sample_rows(rrf, num=MAX_EXAMPLES) for rrf in RRF_FILES}
selections = load_previous()

app = Flask(__name__)

TEMPLATE = """<!doctype html>
<html>
<head><title>Review Fields</title></head>
<body>
  <h1>Review Fields</h1>
  {% if message %}<p style='color: green;'>{{ message }}</p>{% endif %}
  <form method='post'>
    {% for rrf, cols in tables.items() %}
      <h2>{{ rrf }}</h2>
      <table border='1'>
        <tr>
          <th>Delete</th>
          <th>Column</th>
          {% for i in range(max_examples) %}
            <th>Example {{ i + 1 }}</th>
          {% endfor %}
        </tr>
        {% for idx, col in enumerate(cols) %}
        <tr>
          <td><input type='checkbox' name='{{ rrf }}::{{ col }}' {% if selections.get(rrf, {}).get(col) %}checked{% endif %}></td>
          <td>{{ col }}</td>
          {% for row in samples[rrf] %}
            <td>{{ row[idx] if idx < row|length else '' }}</td>
          {% endfor %}
          {% for _ in range(max_examples - samples[rrf]|length) %}<td></td>{% endfor %}
        </tr>
        {% endfor %}
      </table>
    {% endfor %}
    <button type='submit'>Save choices</button>
  </form>
</body>
</html>"""


@app.route('/', methods=['GET', 'POST'])
def index():
    message = ''
    if request.method == 'POST':
        new_sel = {}
        for rrf, cols in tables_by_rrf.items():
            res = {}
            for col in cols:
                key = f"{rrf}::{col}"
                res[col] = key in request.form
            new_sel[rrf] = res
        with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
            json.dump(new_sel, f, indent=2)
        selections.update(new_sel)
        message = 'Selections saved.'
    return render_template_string(
        TEMPLATE,
        tables=tables_by_rrf,
        samples=samples,
        selections=selections,
        max_examples=MAX_EXAMPLES,
        message=message,
    )


def main():
    app.run(debug=True)


if __name__ == '__main__':
    main()
