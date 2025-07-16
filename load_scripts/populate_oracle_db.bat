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

echo     Load word index tables >> oracle.log 2>&1
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_BAQ.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_BAQ.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_CHI.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_CHI.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_CZE.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_CZE.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_DAN.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_DAN.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_DUT.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_DUT.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_ENG.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_ENG.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_EST.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_EST.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_FIN.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_FIN.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_FRE.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_FRE.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_GER.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_GER.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_GRE.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_GRE.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_HEB.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_HEB.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_HUN.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_HUN.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_ITA.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_ITA.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_JPN.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_JPN.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_KOR.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_KOR.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_LAV.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_LAV.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_NOR.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_NOR.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_POL.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_POL.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_POR.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_POR.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_RUS.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_RUS.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_SCR.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_SCR.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_SPA.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_SPA.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_SWE.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_SWE.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MRXW_TUR.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MRXW_TUR.log >> oracle.log

echo     Load auxiliary tables >> oracle.log 2>&1
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="AMBIGSUI.ctl" >> ..\oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type AMBIGSUI.log >> oracle.log
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="AMBIGLUI.ctl" >> ..\oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type AMBIGLUI.log >> oracle.log
cd CHANGE
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="DELETEDCUI.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type DELETEDCUI.log >> ..\oracle.log
cd ..
cd CHANGE
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="DELETEDLUI.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type DELETEDLUI.log >> ..\oracle.log
cd ..
cd CHANGE
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="DELETEDSUI.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type DELETEDSUI.log >> ..\oracle.log
cd ..
cd CHANGE
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MERGEDCUI.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MERGEDCUI.log >> ..\oracle.log
cd ..
cd CHANGE
%ORACLE_HOME%\bin\sqlldr %user%/%password%@%tns_name% control="MERGEDLUI.ctl" >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1)
type MERGEDLUI.log >> ..\oracle.log
cd ..

echo     Create indexes >> oracle.log 2>&1
echo @oracle_indexes.sql|%ORACLE_HOME%\bin\sqlplus %user%/%password%@%tns_name%  >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1

IF %mrcxt_flag% EQU 1 (
del MRCXT.RRF
echo DROP TABLE MRCXT; >> drop_mrcxt.sql
echo @drop_mrcxt.sql|%ORACLE_HOME%\bin\sqlplus %user%/%password%@%tns_name%  >> oracle.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1
del drop_mrcxt.sql
)

:trailer
echo ---------------------------------------- >> oracle.log 2>&1
IF %error% NEQ 0 (
echo There were one or more errors.  Please reference the oracle.log file for details. >> oracle.log 2>&1
set retval=-1
) else (
echo Completed without errors. >> oracle.log 2>&1
set retval=0
)
echo Finished ...  >> oracle.log 2>&1
date /T >> oracle.log 2>&1
time /T >> oracle.log 2>&1
echo ---------------------------------------- >> oracle.log 2>&1
exit %retval%
