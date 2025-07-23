# NLP Applications

This directory contains small web-based demos for running clinical NLP
engines against UMLS resources.  By default it includes support for
[MetaMapLite](https://metamap.nlm.nih.gov/), and starting with this
version also supports running the [Apache cTAKES](https://ctakes.apache.org/)
engine if it is installed locally.

## Running the Demo

Use `serve_metamaplite.sh` to start a local HTTP server from this
directory.  The script will automatically enable CGI support so the
browser-based UI can call the NLP engines.

```
./serve_metamaplite.sh
```

Once running, open <http://localhost:8000> in a browser.  The page
contains a form where you can enter clinical text.  Choose either the
**MetaMapLite** or **cTAKES** engine from the *NLP Engine* menu, then
click **Annotate**.

## cTAKES Requirements

The cTAKES option expects an existing cTAKES installation.  Set the
`CTAKES_HOME` environment variable to point at the installation
directory before starting the server.  The CGI script will attempt to
run `runClinicalPipeline.sh` from this location and return its plain
text output.
