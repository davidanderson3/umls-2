#!/bin/sh -f
#
# For useful information on loading your Metathesaurus subset
# into a MySQL database, please consult the on-line
# documentation at:
#
# http://www.nlm.nih.gov/research/umls/load_scripts.html
#

#
# Database connection parameters
# Please edit these variables to reflect your environment
#

# Note to MySQL users implementing MySQL version 5.6:
# MySQL version 5.6 and above defaults to use the InnoDB storage engine. Users have reported disk space issues while 
# loading RRF data into MySQL 5.6 databases due to default InnoDB settings that store all tables and indexes within the 
# system tablespace. MySQL 5.6.6 now sets the 'innodb_file_per_table' configuration setting to 'on' so that each newly 
# created table and index are assigned a separate .idb data file. Users should read the MySQL documentation for 
# additional information.

MYSQL_HOME=/path/to/MYSQL_HOME
user=username
password=password
db_name=db_name

/bin/rm -f mysql.log
touch mysql.log
ef=0
echo "See mysql.log for output"

echo "----------------------------------------" >> mysql.log 2>&1
echo "Starting ... `/bin/date`" >> mysql.log 2>&1
echo "----------------------------------------" >> mysql.log 2>&1
echo "MYSQL_HOME = $MYSQL_HOME" >> mysql.log 2>&1
echo "user =       $user" >> mysql.log 2>&1
echo "db_name =    $db_name" >> mysql.log 2>&1


echo "    Create and load tables ... `/bin/date`" >> mysql.log 2>&1
$MYSQL_HOME/bin/mysql --local-infile=1 -vvv -u $user -p$password $db_name < mysql_tables.sql >> mysql.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi

echo "finished loading tables ... `/bin/date`" >> mysql.log 2>&1

if [ $ef -ne 1 ]
then
echo "    Create indexes ... `/bin/date`" >> mysql.log 2>&1
$MYSQL_HOME/bin/mysql --local-infile=1 -vvv -u $user -p$password $db_name < mysql_indexes.sql >> mysql.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
fi

echo "finished indexes ... `/bin/date`" >> mysql.log 2>&1



echo "----------------------------------------" >> mysql.log 2>&1
if [ $ef -eq 1 ]
then
  echo "There were one or more errors.  Please reference the mysql.log file for details." >> mysql.log 2>&1
  retval=-1
else
  echo "Completed without errors." >> mysql.log 2>&1
  retval=0
fi
echo "Finished ... `/bin/date`" >> mysql.log 2>&1
echo "----------------------------------------" >> mysql.log 2>&1
exit $retval
