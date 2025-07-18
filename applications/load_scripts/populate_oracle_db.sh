#!/bin/sh -f
#
# For useful information on loading your Metathesaurus subset
# into an Oracle database, please consult the on-line
# documentation at:
# http://www.nlm.nih.gov/research/umls/load_scripts.html
#
# This script expects only a subset of RRF files in the working
# directory and generates SQL*Loader control files on the fly.

ORACLE_HOME=/path/to/ORACLE_HOME
export ORACLE_HOME
user=username
password=password
tns_name=tns_name
# Default to AL32UTF8 for modern Oracle versions while allowing override
: "${NLS_LANG:=AMERICAN_AMERICA.AL32UTF8}"
export NLS_LANG
# Character set used by SQL*Loader control files
: "${ORA_CHARSET:=AL32UTF8}"

/bin/rm -f oracle.log
mkdir -p tmp_ctl
ef=0

echo "See oracle.log for output"
echo "----------------------------------------" >> oracle.log 2>&1
echo "Starting ... `/bin/date`" >> oracle.log 2>&1
echo "----------------------------------------" >> oracle.log 2>&1
echo "ORACLE_HOME = $ORACLE_HOME" >> oracle.log 2>&1
echo "user =        $user" >> oracle.log 2>&1
echo "tns_name =    $tns_name" >> oracle.log 2>&1

echo "    Create tables ... `/bin/date`" >> oracle.log 2>&1
echo "@oracle_tables.sql" | $ORACLE_HOME/bin/sqlplus $user/$password@$tns_name >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi

load_table() {
  table=$1
  shift
  cat > tmp_ctl/$table.ctl <<CTL
options (direct=true)
load data
characterset $ORA_CHARSET length semantics char
infile '$table.RRF'
badfile '$table.bad'
discardfile '$table.dsc'
truncate
into table $table
fields terminated by '|'
trailing nullcols
$1
CTL
  $ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="tmp_ctl/$table.ctl" >> oracle.log 2>&1
  if [ $? -ne 0 ]; then ef=1; fi
  [ -f $table.log ] && cat $table.log >> oracle.log
  rm -f tmp_ctl/$table.ctl
}

# Load tables
load_table MRCOLS "(COL char(40),\nDES char(200),\nREF char(40),\nMIN integer external,\nAV float external,\nMAX integer external,\nFIL char(50),\nDTY char(40))"
load_table MRCONSO "(CUI char(8),\nLAT char(3),\nTS char(1),\nLUI char(10),\nSTT char(3),\nSUI char(10),\nISPREF char(1),\nAUI char(9),\nSAUI char(50),\nSCUI char(100),\nSDUI char(100),\nSAB char(40),\nTTY char(40),\nCODE char(100),\nSTR char(3000),\nSRL integer external,\nSUPPRESS char(1),\nCVF integer external)"
load_table MRCUI "(CUI1 char(8),\nVER char(10),\nREL char(4),\nRELA char(100),\nMAPREASON char(4000),\nCUI2 char(8),\nMAPIN char(1))"
load_table MRDEF "(CUI char(8),\nAUI char(9),\nATUI char(11),\nSATUI char(50),\nSAB char(40),\nDEF char(4000),\nSUPPRESS char(1),\nCVF integer external)"
load_table MRDOC "(DOCKEY char(50),\nVALUE char(200),\nTYPE char(50),\nEXPL char(1000))"
load_table MRFILES "(FIL char(50),\nDES char(200),\nFMT char(300),\nCLS integer external,\nRWS integer external,\nBTS integer external)"
load_table MRHIER "(CUI char(8),\nAUI char(9),\nCXN integer external,\nPAUI char(10),\nSAB char(40),\nRELA char(100),\nPTR char(1000),\nHCD char(100),\nCVF integer external)"
load_table MRRANK "(RANK integer external,\nSAB char(40),\nTTY char(40),\nSUPPRESS char(1))"
load_table MRREL "(CUI1 char(8),\nAUI1 char(9),\nSTYPE1 char(50),\nREL char(4),\nCUI2 char(8),\nAUI2 char(9),\nSTYPE2 char(50),\nRELA char(100),\nRUI char(10),\nSRUI char(50),\nSAB char(40),\nSL char(40),\nRG char(10),\nDIR char(1),\nSUPPRESS char(1),\nCVF integer external)"
load_table MRSAB "(VCUI char(8),\nRCUI char(8),\nVSAB char(40),\nRSAB char(40),\nSON char(3000),\nSF char(40),\nSVER char(40),\nVSTART char(8),\nVEND char(8),\nIMETA char(10),\nRMETA char(10),\nSLC char(1000),\nSCC char(1000),\nSRL integer external,\nTFR integer external,\nCFR integer external,\nCXTY char(50),\nTTYL char(400),\nATNL char(4000),\nLAT char(3),\nCENC char(40),\nCURVER char(1),\nSABIN char(1),\nSSN char(3000),\nSCIT char(4000))"
load_table MRSAT "(CUI char(8),\nLUI char(10),\nSUI char(10),\nMETAUI char(100),\nSTYPE char(50),\nCODE char(100),\nATUI char(11),\nSATUI char(50),\nATN char(100),\nSAB char(40),\nATV char(4000),\nSUPPRESS char(1),\nCVF integer external)"
load_table MRSTY "(CUI char(8),\nTUI char(4),\nSTN char(100),\nSTY char(50),\nATUI char(11),\nCVF integer external)"
load_table MRXNS_ENG "(LAT char(3),\nNSTR char(3000),\nCUI char(8),\nLUI char(10),\nSUI char(10))"
load_table MRXNW_ENG "(LAT char(3),\nNWD char(200),\nCUI char(8),\nLUI char(10),\nSUI char(10))"
load_table MRAUI "(AUI1 char(9),\nCUI1 char(8),\nVER char(10),\nREL char(4),\nRELA char(100),\nMAPREASON char(4000),\nAUI2 char(9),\nCUI2 char(8),\nMAPIN char(1))"

# Create indexes
if [ $ef -ne 1 ]; then
  echo "    Create indexes ... `/bin/date`" >> oracle.log 2>&1
  echo "@oracle_indexes.sql" | $ORACLE_HOME/bin/sqlplus $user/$password@$tns_name >> oracle.log 2>&1
  if [ $? -ne 0 ]; then ef=1; fi
fi

rm -rf tmp_ctl

echo "----------------------------------------" >> oracle.log 2>&1
if [ $ef -eq 1 ]; then
  echo "There were one or more errors.  Please reference the oracle.log file for details." >> oracle.log 2>&1
  retval=-1
else
  echo "Completed without errors." >> oracle.log 2>&1
  retval=0
fi
echo "Finished ... `/bin/date`" >> oracle.log 2>&1
echo "----------------------------------------" >> oracle.log 2>&1
exit $retval
