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

Oracle loader scripts are still provided, but the `.ctl` files have been removed. `populate_oracle_db.sh` will generate them automatically. Use `populate_mysql_db.sh` (or the Windows batch equivalent) to load the data into MySQL.

The MySQL loader script now explicitly enables `LOCAL` file loading so it works
with MySQL 8.0 and later. Oracle scripts default to the `AL32UTF8` character
set for better compatibility with modern Oracle releases. You can override these
defaults by setting `--local-infile=1` in your MySQL client or setting the
`NLS_LANG` and `ORA_CHARSET` environment variables before running the Oracle
loader script.
