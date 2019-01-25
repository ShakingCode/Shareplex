

alter session set container=oraclepdb;
alter pluggable database oraclepdb open read write;

-- 18c
CREATE TABLESPACE "QUEST_SHAREPLEX" DATAFILE 'C:\DATABASES\ORACLE\18C\ORADATA\ORACLEDB\ORACLEPDB\SHAREPLEX01.DBF' SIZE 104857600 REUSE;
--12c
CREATE TABLESPACE "QUEST_SHAREPLEX" DATAFILE 'C:\DATABASES\ORACLE\12C\ORADATA\ORACLE12C\ORACLEPDB\SHAREPLEX01.DBF' SIZE 104857600 REUSE;


alter session set container=cdb$root;
ALTER DATABASE FORCE LOGGING;
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY, UNIQUE) COLUMNS;
ALTER SYSTEM SWITCH LOGFILE;

create user c##sp_admin identified by sp_admin;
grant dba to c##sp_admin container=ALL;
grant select on sys.user$ to c##sp_admin with grant option container=ALL;
grant select on sys.enc$ to c##sp_admin with grant option container=ALL;

create user sergio 
identified by sergio 
default tablespace "USERS"
temporary tablespace "TEMP";

grant connect, resource to sergio;
grant create session to sergio;
grant unlimited tablespace to sergio;

-- /!\: Add to tnsnames.ora the pdb database

set ORACLE_SID=oraclepdb
set ORACLE_HOME=C:\Databases\Oracle\12c\product\12.1.0\dbhome_1
set ORACLE_BASE=C:\Databases\Oracle\12c
set NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252

-- SHAREPLEX
set SP_SYS_VARDIR="C:\Program Files\Quest Software\SharePlex\vardir2100"
set SP_COP_UPORT=2100
set SP_COP_TPORT=2100

grant select on sys.user$ to sergio with grant option container=ALL;
grant select on sys.enc$ to sergio with grant option container=ALL;

chown -R postgres:postgres /u01
chmod -R 775 /u01
