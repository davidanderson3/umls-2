options (direct=true)
load data
characterset UTF8 length semantics char
infile 'MRXNW_ENG.RRF'
badfile 'MRXNW_ENG.bad'
discardfile 'MRXNW_ENG.dsc'
truncate
into table MRXNW_ENG
fields terminated by '|'
trailing nullcols
(LAT	char(3),
NWD	char(200),
CUI	char(8),
LUI	char(10),
SUI	char(10)
)