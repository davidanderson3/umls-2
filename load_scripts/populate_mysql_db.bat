::
:: For useful information on loading your Metathesaurus subset
:: into a MySQL database, please consult the on-line
:: documentation at:
::
:: http://www.nlm.nih.gov/research/umls/load_scripts.html
::

::
:: Database connection parameters
:: Please edit these variables to reflect your environment
::

::Note to MySQL users implementing MySQL version 5.6:
::MySQL version 5.6 and above defaults to use the InnoDB storage engine. Users have reported disk space issues while 
::loading RRF data into MySQL 5.6 databases due to default InnoDB settings that store all tables and indexes within the 
::system tablespace. MySQL 5.6.6 now sets the 'innodb_file_per_table' configuration setting to 'on' so that each newly 
::created table and index are assigned a separate .idb data file. Users should read the MySQL documentation for 
::additional information.

set MYSQL_HOME=<path to MYSQL_HOME>
set user=<username>
set password=<password>
set db_name=<db_name>

del mysql.log
echo. > mysql.log
echo ---------------------------------------- >> mysql.log 2>&1
echo Starting ...  >> mysql.log 2>&1
date /T >> mysql.log 2>&1
time /T >> mysql.log 2>&1
echo ---------------------------------------- >> mysql.log 2>&1
echo MYSQL_HOME = %MYSQL_HOME% >> mysql.log 2>&1
echo user =       %user% >> mysql.log 2>&1
echo db_name =    %db_name% >> mysql.log 2>&1
set error=0
set mrcxt_flag=0

:: Create empty mrcxt if it doesn't exist, expected by mysql_tables.sql script
if not exist MRCXT.RRF set mrcxt_flag=1
if not exist MRCXT.RRF TYPE NUL > MRCXT.RRF

echo     Create and load tables >> mysql.log 2>&1
%MYSQL_HOME%\bin\mysql -vvv -u %user% -p%password% --local-infile=1 %db_name%  < mysql_tables.sql >> mysql.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1
goto trailer)

echo     Create indexes >> mysql.log 2>&1
%MYSQL_HOME%\bin\mysql -vvv -u %user% -p%password% --local-infile=1 %db_name% < mysql_indexes.sql >> mysql.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1

IF %mrcxt_flag% EQU 1 (
del MRCXT.RRF
echo DROP TABLE IF EXISTS MRCXT; >> drop_mrcxt.sql
%MYSQL_HOME%\bin\mysql -vvv -u %user% -p%password% --local-infile=1 %db_name% < drop_mrcxt.sql >> mysql.log 2>&1
IF %ERRORLEVEL% NEQ 0 (set error=1
del drop_mrcxt.sql
)

:trailer
echo ---------------------------------------- >> mysql.log 2>&1
IF %error% NEQ 0 (
echo There were one or more errors.  Please reference the mysql.log file for details. >> mysql.log 2>&1
set retval=-1
) else (
echo Completed without errors. >> mysql.log 2>&1
set retval=0
)
echo Finished ...  >> mysql.log 2>&1
date /T >> mysql.log 2>&1
time /T >> mysql.log 2>&1
echo ---------------------------------------- >> mysql.log 2>&1
exit %retval%
