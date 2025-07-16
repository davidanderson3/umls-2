options (direct=true)
load data
characterset UTF8 length semantics char
infile 'MRRANK.RRF'
badfile 'MRRANK.bad'
discardfile 'MRRANK.dsc'
truncate
into table MRRANK
fields terminated by '|'
trailing nullcols
(RANK	integer external,
SAB	char(40),
TTY	char(40),
SUPPRESS	char(1)
)