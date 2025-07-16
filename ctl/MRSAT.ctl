options (direct=true)
load data
characterset UTF8 length semantics char
infile 'MRSAT.RRF'
badfile 'MRSAT.bad'
discardfile 'MRSAT.dsc'
truncate
into table MRSAT
fields terminated by '|'
trailing nullcols
(CUI	char(8),
LUI	char(10),
SUI	char(10),
METAUI	char(100),
STYPE	char(50),
CODE	char(100),
ATUI	char(11),
SATUI	char(50),
ATN	char(100),
SAB	char(40),
ATV	char(4000),
SUPPRESS	char(1),
CVF	integer external
)