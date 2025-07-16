# UMLS Evaluation Tool

This folder contains a small command line tool for inspecting fields
in UMLS RRF files.  The tool reads the `.ctl` files in this repository to
retrieve the column names for each UMLS file and presents an interactive
prompt that lets you decide whether to keep each field.

Decisions are stored in a JSON file so that evaluations can be resumed
later or shared with others.  Multiple RRF files can be joined together
on a common key to provide additional context while evaluating.
