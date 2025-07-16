# umls-2

This repository contains simplified load scripts for a subset of the UMLS Metathesaurus.
Only the following RRF files are expected in the `META` directory:

- `MRCOLS.RRF`
- `MRCONSO.RRF`
- `MRCUI.RRF`
- `MRDEF.RRF`
- `MRDOC.RRF`
- `MRFILES.RRF`
- `MRHIER.RRF`
- `MRRANK.RRF`
- `MRREL.RRF`
- `MRSAB.RRF`
- `MRSAT.RRF`
- `MRSTY.RRF`
- `MRXNS_ENG.RRF`
- `MRXNW_ENG.RRF`
- `MRAUI.RRF`

Oracle specific scripts and control (`.ctl`) files have been removed. Use `populate_mysql_db.sh` (or the Windows batch equivalent) to load the data into MySQL.

## Reviewing Metathesaurus Fields

The `review_fields.py` script provides a small interactive CLI for inspecting the
columns of each RRF file and marking them for deletion. The script expects the
RRF files to be present in the current directory.

```bash
python3 review_fields.py
```

After completing the prompts, your selections are saved to
`field_review_results.json`.
