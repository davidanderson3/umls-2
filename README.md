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
