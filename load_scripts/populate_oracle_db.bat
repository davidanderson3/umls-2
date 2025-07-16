::
:: For useful information on loading your Metathesaurus subset
:: into a Oracle database, please consult the on-line
:: documentation at:
::
:: http://www.nlm.nih.gov/research/umls/load_scripts.html
::

::
:: Database connection parameters
:: Please edit these variables to reflect your environment
::
set ORACLE_HOME=<path to ORACLE_HOME>
set user=<username>
set password=<password>
set tns_name=<tns_name>
set NLS_LANG=AMERICAN_AMERICA.UTF8

del oracle.log
echo. > oracle.log
echo ---------------------------------------- >> oracle.log 2>&1
echo Starting ...  >> oracle.log 2>&1
date /T >> oracle.log 2>&1
time /T >> oracle.log 2>&1
echo ---------------------------------------- >> oracle.log 2>&1
echo ORACLE_HOME = %ORACLE_HOME% >> oracle.log 2>&1
echo user =        %user% >> oracle.log 2>&1
echo tns_name =    %tns_name% >> oracle.log 2>&1
set error=0
set mrcxt_flag=0

:: Create empty mrcxt if it doesn't exist, expected by oracle_tables.sql script
if not exist MRCXT.RRF set mrcxt_flag=1
if not exist MRCXT.RRF TYPE NUL > MRCXT.RRF

echo     Create tables >> oracle.log 2>&1
echo @oracle_tables.sql|%ORACLE_HOME%\bin\sqlplus %user%/%password%@%tns_name%  >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1
goto trailer)

echo     Load content tables >> oracle.log 2>&1
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRCOLS.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRCOLS.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRCONSO.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRCONSO.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRCUI.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRCUI.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRCXT.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRCXT.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRDEF.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRDEF.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRDOC.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRDOC.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRFILES.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRFILES.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRHIER.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRHIER.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRHIST.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRHIST.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRMAP.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRMAP.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRRANK.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRRANK.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRREL.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRREL.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRSAB.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRSAB.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRSAT.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRSAT.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRSMAP.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRSMAP.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRSTY.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRSTY.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXNS_ENG.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXNS_ENG.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXNW_ENG.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXNW_ENG.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRAUI.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRAUI.log >> oracle.log
