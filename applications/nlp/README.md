# NLP Applications

This directory contains small web-based demos for running clinical NLP
engines against UMLS resources.  By default it includes support for
[MetaMapLite](https://metamap.nlm.nih.gov/) and
[QuickUMLS](https://github.com/Georgetown-IR-Lab/QuickUMLS).  It also
supports running the [Apache cTAKES](https://ctakes.apache.org/)
engine if it is installed locally.

## Running the Demo

Use `serve_metamaplite.sh` to start a local HTTP server from this
directory.  The script will automatically enable CGI support so the
browser-based UI can call the NLP engines.

```
./serve_metamaplite.sh
```

Once running, open <http://localhost:8000> in a browser.  The page
contains a form where you can enter clinical text.  Choose an engine
from the *NLP Engine* menu—**MetaMapLite**, **QuickUMLS**, or
**cTAKES**—then click **Annotate**.

## cTAKES Requirements

The cTAKES option expects an existing cTAKES installation.  Set the
`CTAKES_HOME` environment variable to point at the installation
directory before starting the server.  The CGI script will attempt to
run `runClinicalPipeline.sh` from this location and return its plain
text output.

## QuickUMLS Requirements

The QuickUMLS option requires the QuickUMLS Python package and a data
directory built from your local UMLS installation.

1. Install the package and its dependencies:

   ```bash
   pip install quickumls
   ```

2. Build the QuickUMLS data files using your UMLS release:

   ```bash
   python -m quickumls.install /path/to/umls /path/to/quickumls_data
   ```

3. Set the `QUICKUMLS_DIR` environment variable to the directory created
   in the previous step before starting the server:

   ```bash
   export QUICKUMLS_DIR=/path/to/quickumls_data
   ```

When these are in place, restart `serve_metamaplite.sh` and choose the
**QuickUMLS** engine in the demo interface.

If `runClinicalPipeline.sh` cannot be found under `CTAKES_HOME/bin`, the
CGI script prints `Error: cTAKES not installed`.

### Installing cTAKES

1. Download a cTAKES release from <https://ctakes.apache.org> and
   extract it somewhere on your system.
2. Set the `CTAKES_HOME` environment variable to the extracted
   directory:

   ```bash
   export CTAKES_HOME=/path/to/apache-ctakes-<version>
   ```
3. Start the demo server:

   ```bash
   ./serve_metamaplite.sh
   ```
4. Open <http://localhost:8000> in your browser, enter clinical text,
   select **cTAKES** from the *NLP Engine* menu and click **Annotate**.

Once `CTAKES_HOME` is set correctly and cTAKES is installed, the demo
will call cTAKES instead of displaying the error message.
