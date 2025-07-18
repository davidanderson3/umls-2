import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / 'load_scripts'

MYSQL_SH = ROOT / 'populate_mysql_db.sh'
ORACLE_SH = ROOT / 'populate_oracle_db.sh'
MYSQL_SQL = ROOT / 'mysql_tables.sql'
ORACLE_SQL = ROOT / 'oracle_tables.sql'


def test_mysql_script_syntax():
    result = subprocess.run(['sh', '-n', str(MYSQL_SH)], capture_output=True)
    assert result.returncode == 0, result.stderr.decode()


def test_oracle_script_syntax():
    result = subprocess.run(['sh', '-n', str(ORACLE_SH)], capture_output=True)
    assert result.returncode == 0, result.stderr.decode()


def test_mysql_uses_local_infile():
    content = MYSQL_SH.read_text()
    assert '--local-infile=1' in content


def test_oracle_sets_charset():
    content = ORACLE_SH.read_text()
    assert 'NLS_LANG' in content
    assert 'ORA_CHARSET' in content


def test_mysql_tables_load_infile():
    sql = MYSQL_SQL.read_text()
    assert 'load data local infile' in sql.lower()


def test_oracle_tables_length_semantics():
    sql = ORACLE_SQL.read_text().lower()
    assert 'alter session set nls_length_semantics' in sql
