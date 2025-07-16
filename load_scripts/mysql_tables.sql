\W

DROP TABLE IF EXISTS MRCOLS;
CREATE TABLE MRCOLS (
    COL	varchar(40),
    DES	varchar(200),
    REF	varchar(40),
    MIN	int unsigned,
    AV	numeric(5,2),
    MAX	int unsigned,
    FIL	varchar(50),
    DTY	varchar(40)
) CHARACTER SET utf8;

load data local infile 'MRCOLS.RRF' into table MRCOLS fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@col,@des,@ref,@min,@av,@max,@fil,@dty)
SET COL = NULLIF(@col,''),
DES = NULLIF(@des,''),
REF = NULLIF(@ref,''),
MIN = NULLIF(@min,''),
AV = NULLIF(@av,''),
MAX = NULLIF(@max,''),
FIL = NULLIF(@fil,''),
DTY = NULLIF(@dty,'');

DROP TABLE IF EXISTS MRCONSO;
CREATE TABLE MRCONSO (
    CUI	char(8) NOT NULL,
    LAT	char(3) NOT NULL,
    TS	char(1) NOT NULL,
    LUI	varchar(10) NOT NULL,
    STT	varchar(3) NOT NULL,
    SUI	varchar(10) NOT NULL,
    ISPREF	char(1) NOT NULL,
    AUI	varchar(9) NOT NULL,
    SAUI	varchar(50),
    SCUI	varchar(100),
    SDUI	varchar(100),
    SAB	varchar(40) NOT NULL,
    TTY	varchar(40) NOT NULL,
    CODE	varchar(100) NOT NULL,
    STR	text NOT NULL,
    SRL	int unsigned NOT NULL,
    SUPPRESS	char(1) NOT NULL,
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRCONSO.RRF' into table MRCONSO fields terminated by '|' ESCAPED BY '' lines terminated by @LINE_TERMINATION@
(@cui,@lat,@ts,@lui,@stt,@sui,@ispref,@aui,@saui,@scui,@sdui,@sab,@tty,@code,@str,@srl,@suppress,@cvf)
SET CUI = @cui,
LAT = @lat,
TS = @ts,
LUI = @lui,
STT = @stt,
SUI = @sui,
ISPREF = @ispref,
AUI = @aui,
SAUI = NULLIF(@saui,''),
SCUI = NULLIF(@scui,''),
SDUI = NULLIF(@sdui,''),
SAB = @sab,
TTY = @tty,
CODE = @code,
STR = @str,
SRL = @srl,
SUPPRESS = @suppress,
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRCUI;
CREATE TABLE MRCUI (
    CUI1	char(8) NOT NULL,
    VER	varchar(10) NOT NULL,
    REL	varchar(4) NOT NULL,
    RELA	varchar(100),
    MAPREASON	text,
    CUI2	char(8),
    MAPIN	char(1)
) CHARACTER SET utf8;

load data local infile 'MRCUI.RRF' into table MRCUI fields terminated by '|' lines terminated by @LINE_TERMINATION@
(@cui1,@ver,@rel,@rela,@mapreason,@cui2,@mapin)
SET CUI1 = @cui1,
VER = @ver,
REL = @rel,
RELA = NULLIF(@rela,''),
MAPREASON = NULLIF(@mapreason,''),
CUI2 = NULLIF(@cui2,''),
MAPIN = NULLIF(@mapin,'');


DROP TABLE IF EXISTS MRDEF;
CREATE TABLE MRDEF (
    CUI	char(8) NOT NULL,
    AUI	varchar(9) NOT NULL,
    ATUI	varchar(11) NOT NULL,
    SATUI	varchar(50),
    SAB	varchar(40) NOT NULL,
    DEF	text NOT NULL,
    SUPPRESS	char(1) NOT NULL,
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRDEF.RRF' into table MRDEF fields terminated by '|' ESCAPED BY '' lines terminated by @LINE_TERMINATION@
(@cui,@aui,@atui,@satui,@sab,@def,@suppress,@cvf)
SET CUI = @cui,
AUI = @aui,
ATUI = @atui,
SATUI = NULLIF(@satui,''),
SAB = @sab,
DEF = @def,
SUPPRESS = @suppress,
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRDOC;
CREATE TABLE MRDOC (
    DOCKEY	varchar(50) NOT NULL,
    VALUE	varchar(200),
    TYPE	varchar(50) NOT NULL,
    EXPL	text
) CHARACTER SET utf8;

load data local infile 'MRDOC.RRF' into table MRDOC fields terminated by '|' ESCAPED BY '' lines terminated by @LINE_TERMINATION@
(@dockey,@value,@type,@expl)
SET DOCKEY = @dockey,
VALUE = NULLIF(@value,''),
TYPE = @type,
EXPL = NULLIF(@expl,'');

DROP TABLE IF EXISTS MRFILES;
CREATE TABLE MRFILES (
    FIL	varchar(50),
    DES	varchar(200),
    FMT	text,
    CLS	int unsigned,
    RWS	int unsigned,
    BTS	bigint
) CHARACTER SET utf8;

load data local infile 'MRFILES.RRF' into table MRFILES fields terminated by '|' ESCAPED BY '' lines terminated by @LINE_TERMINATION@
(@fil,@des,@fmt,@cls,@rws,@bts)
SET FIL = NULLIF(@fil,''),
DES = NULLIF(@des,''),
FMT = NULLIF(@fmt,''),
CLS = NULLIF(@cls,''),
RWS = NULLIF(@rws,''),
BTS = NULLIF(@bts,'');

DROP TABLE IF EXISTS MRHIER;
CREATE TABLE MRHIER (
    CUI	char(8) NOT NULL,
    AUI	varchar(9) NOT NULL,
    CXN	int unsigned NOT NULL,
    PAUI	varchar(10),
    SAB	varchar(40) NOT NULL,
    RELA	varchar(100),
    PTR	text,
    HCD	varchar(100),
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRHIER.RRF' into table MRHIER fields terminated by '|' ESCAPED BY '' lines terminated by @LINE_TERMINATION@
(@cui,@aui,@cxn,@paui,@sab,@rela,@ptr,@hcd,@cvf)
SET CUI = @cui,
AUI = @aui,
CXN = @cxn,
PAUI = NULLIF(@paui,''),
SAB = @sab,
RELA = NULLIF(@rela,''),
PTR = NULLIF(@ptr,''),
HCD = NULLIF(@hcd,''),
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRRANK;
CREATE TABLE MRRANK (
    MRRANK_RANK	int unsigned NOT NULL,
    SAB	varchar(40) NOT NULL,
    TTY	varchar(40) NOT NULL,
    SUPPRESS	char(1) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRRANK.RRF' into table MRRANK fields terminated by '|' ESCAPED BY '' lines terminated by @LINE_TERMINATION@
(@mrrank_rank,@sab,@tty,@suppress)
SET MRRANK_RANK = @mrrank_rank,
SAB = @sab,
TTY = @tty,
SUPPRESS = @suppress;

DROP TABLE IF EXISTS MRREL;
CREATE TABLE MRREL (
    CUI1	char(8) NOT NULL,
    AUI1	varchar(9),
    STYPE1	varchar(50) NOT NULL,
    REL	varchar(4) NOT NULL,
    CUI2	char(8) NOT NULL,
    AUI2	varchar(9),
    STYPE2	varchar(50) NOT NULL,
    RELA	varchar(100),
    RUI	varchar(10) NOT NULL,
    SRUI	varchar(50),
    SAB	varchar(40) NOT NULL,
    SL	varchar(40) NOT NULL,
    RG	varchar(10),
    DIR	varchar(1),
    SUPPRESS	char(1) NOT NULL,
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRREL.RRF' into table MRREL fields terminated by '|' ESCAPED BY '' lines terminated by @LINE_TERMINATION@
(@cui1,@aui1,@stype1,@rel,@cui2,@aui2,@stype2,@rela,@rui,@srui,@sab,@sl,@rg,@dir,@suppress,@cvf)
SET CUI1 = @cui1,
AUI1 = NULLIF(@aui1,''),
STYPE1 = @stype1,
REL = @rel,
CUI2 = @cui2,
AUI2 = NULLIF(@aui2,''),
STYPE2 = @stype2,
RELA = NULLIF(@rela,''),
RUI = @rui,
SRUI = NULLIF(@srui,''),
SAB = @sab,
SL = @sl,
RG = NULLIF(@rg,''),
DIR = NULLIF(@dir,''),
SUPPRESS = @suppress,
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRSAB;
CREATE TABLE MRSAB (
    VCUI	char(8),
    RCUI	char(8),
    VSAB	varchar(40) NOT NULL,
    RSAB	varchar(40) NOT NULL,
    SON	text NOT NULL,
    SF	varchar(40) NOT NULL,
    SVER	varchar(40),
    VSTART	char(8),
    VEND	char(8),
    IMETA	varchar(10) NOT NULL,
    RMETA	varchar(10),
    SLC	text,
    SCC	text,
    SRL	int unsigned NOT NULL,
    TFR	int unsigned,
    CFR	int unsigned,
    CXTY	varchar(50),
    TTYL	varchar(400),
    ATNL	text,
    LAT	char(3),
    CENC	varchar(40) NOT NULL,
    CURVER	char(1) NOT NULL,
    SABIN	char(1) NOT NULL,
    SSN	text NOT NULL,
    SCIT	text NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRSAB.RRF' into table MRSAB fields terminated by '|' ESCAPED BY '' lines terminated by @LINE_TERMINATION@
(@vcui,@rcui,@vsab,@rsab,@son,@sf,@sver,@vstart,@vend,@imeta,@rmeta,@slc,@scc,@srl,@tfr,@cfr,@cxty,@ttyl,@atnl,@lat,@cenc,@curver,@sabin,@ssn,@scit)
SET VCUI = NULLIF(@vcui,''),
RCUI = @rcui,
VSAB = @vsab,
RSAB = @rsab,
SON = @son,
SF = @sf,
SVER = NULLIF(@sver,''),
VSTART = NULLIF(@vstart,''),
VEND = NULLIF(@vend,''),
IMETA = @imeta,
RMETA = NULLIF(@rmeta,''),
SLC = NULLIF(@slc,''),
SCC = NULLIF(@scc,''),
SRL = @srl,
TFR = NULLIF(@tfr,''),
CFR = NULLIF(@cfr,''),
CXTY = NULLIF(@cxty,''),
TTYL = NULLIF(@ttyl,''),
ATNL = NULLIF(@atnl,''),
LAT = NULLIF(@lat,''),
CENC = @cenc,
CURVER = @curver,
SABIN = @sabin,
SSN = @ssn,
SCIT = @scit;

DROP TABLE IF EXISTS MRSAT;
CREATE TABLE MRSAT (
    CUI	char(8) NOT NULL,
    LUI	varchar(10),
    SUI	varchar(10),
    METAUI	varchar(100),
    STYPE	varchar(50) NOT NULL,
    CODE	varchar(100),
    ATUI	varchar(11) NOT NULL,
    SATUI	varchar(50),
    ATN	varchar(100) NOT NULL,
    SAB	varchar(40) NOT NULL,
    ATV	text,
    SUPPRESS	char(1) NOT NULL,
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRSAT.RRF' into table MRSAT fields terminated by '|' ESCAPED BY '' lines terminated by @LINE_TERMINATION@
(@cui,@lui,@sui,@metaui,@stype,@code,@atui,@satui,@atn,@sab,@atv,@suppress,@cvf)
SET CUI = @cui,
LUI = NULLIF(@lui,''),
SUI = NULLIF(@sui,''),
METAUI = NULLIF(@metaui,''),
STYPE = @stype,
CODE = NULLIF(@code,''),
ATUI = @atui,
SATUI = NULLIF(@satui,''),
ATN = @atn,
SAB = @sab,
ATV = @atv,
SUPPRESS = @suppress,
CVF = NULLIF(@cvf,'');


DROP TABLE IF EXISTS MRSTY;
CREATE TABLE MRSTY (
    CUI	char(8) NOT NULL,
    TUI	char(4) NOT NULL,
    STN	varchar(100) NOT NULL,
    STY	varchar(50) NOT NULL,
    ATUI	varchar(11) NOT NULL,
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRSTY.RRF' into table MRSTY fields terminated by '|' ESCAPED BY '' lines terminated by @LINE_TERMINATION@
(@cui,@tui,@stn,@sty,@atui,@cvf)
SET CUI = @cui,
TUI = @tui,
STN = @stn,
STY = @sty,
ATUI = @atui,
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRXNS_ENG;
CREATE TABLE MRXNS_ENG (
    LAT	char(3) NOT NULL,
    NSTR	text NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXNS_ENG.RRF' into table MRXNS_ENG fields terminated by '|' ESCAPED BY '' lines terminated by @LINE_TERMINATION@
(@lat,@nstr,@cui,@lui,@sui)
SET LAT = @lat,
NSTR = @nstr,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXNW_ENG;
CREATE TABLE MRXNW_ENG (
    LAT	char(3) NOT NULL,
    NWD	varchar(100) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXNW_ENG.RRF' into table MRXNW_ENG fields terminated by '|' ESCAPED BY '' lines terminated by @LINE_TERMINATION@
(@lat,@nwd,@cui,@lui,@sui)
SET LAT = @lat,
NWD = @nwd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRAUI;
CREATE TABLE MRAUI (
    AUI1	varchar(9) NOT NULL,
    CUI1	char(8) NOT NULL,
    VER	varchar(10) NOT NULL,
    REL	varchar(4),
    RELA	varchar(100),
    MAPREASON	text NOT NULL,
    AUI2	varchar(9) NOT NULL,
    CUI2	char(8) NOT NULL,
    MAPIN	char(1) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRAUI.RRF' into table MRAUI fields terminated by '|' ESCAPED BY '' lines terminated by @LINE_TERMINATION@
(@aui1,@cui1,@ver,@rel,@rela,@mapreason,@aui2,@cui2,@mapin)
SET AUI1 = @aui1,
CUI1 = @cui1,
VER = @ver,
REL = NULLIF(@rel,''),
RELA = NULLIF(@rela,''),
MAPREASON = @mapreason,
AUI2 = @aui2,
CUI2 = @cui2,
MAPIN = @mapin;

