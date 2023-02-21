ALTER DATABASE OPEN
--                    TASK 1
CREATE TABLESPACE TS_GAE 
    DATAFILE 'C:\Tablespaces\TS_GAE1.dbf'
    SIZE 7m
    REUSE AUTOEXTEND ON NEXT 5m
    MAXSIZE 20m;
COMMIT;    
DROP TABLESPACE TS_GAE INCLUDING CONTENTS AND DATAFILES;

--                    TASK 2
CREATE TEMPORARY TABLESPACE TS_GAE_TEMP
    TEMPFILE 'C:\Oracle_setup\app\Tablespaces\TS_GAE_TEMP1.dbf'
    SIZE 5m
    REUSE AUTOEXTEND ON NEXT 3m
    MAXSIZE 30m;
COMMIT; 
DROP TABLESPACE TS_GAE_TEMP INCLUDING CONTENTS AND DATAFILES;
--                    TASK 3
SELECT TABLESPACE_NAME, STATUS, contents  from SYS.dba_tablespaces;
--                    TASK 4
alter session set container=GAE_PDB;

CREATE ROLE RL_GAECORE;

grant create session, create table, create view, create procedure to RL_GAECORE;
grant drop any table, drop any view, drop any procedure to RL_GAECORE;

--                    TASK 5
SELECT * FROM DBA_ROLES WHERE role='RL_GAECORE';
SELECT * FROM DBA_SYS_PRIVS WHERE grantee='RL_GAECORE';

DROP ROLE RL_GAECORE;
--                    TASK 6

CREATE PROFILE PF_GAECORE LIMIT
  password_life_time 180        
  sessions_per_user 3           
  failed_login_attempts 7       
  password_lock_time 1          
  password_reuse_time 10        
  password_grace_time default   
  connect_time 180              
  idle_time 30; 
  
DROP PROFILE PF_GAECORE;


--                    TASK 7
select * from DBA_PROFILES;
select * from DBA_PROFILES where profile='PF_GAECORE';  
select * from DBA_PROFILES where profile='DEFAULT';

--                    TASK 8
CREATE USER GAECORE identified by 1234
  default tablespace TS_GAE         
        quota unlimited on TS_GAE  
  temporary tablespace TS_GAE_TEMP  
  profile PF_GAECORE                
  account unlock                    
  password expire;                  

GRANT RL_GAECORE to GAECORE;
GRANT CREATE TABLESPACE, ALTER TABLESPACE to GAECORE;

select * from DBA_USERS;

DROP USER GAECORE;


--                    TASK 9
GAECORE/1234@//localhost:1521/pdb_1
12345
12345

--                    TASK 10

CREATE TABLE GAE_TABLE(
id number GENERATED ALWAYS AS IDENTITY primary key,
word varchar2(50) NOT NULL);

INSERT  into GAE_TABLE(word) values('Apple');
INSERT  into GAE_TABLE(word) values('Juice');
INSERT  into GAE_TABLE(word) values('Banana');


CREATE VIEW three_entries AS SELECT * FROM GAE_TABLE WHERE id<=3;

SELECT * FROM GAE_TABLE;
SELECT * FROM three_entries;


DROP TABLE GAE_TABLE;
DROP VIEW three_entries;

--                    TASK 11

CREATE TABLESPACE GAE_QDATA OFFLINE
  DATAFILE 'C:\Oracle_setup\app\Tablespaces\GAE_QDATA.txt'
  SIZE 10m REUSE
  AUTOEXTEND ON NEXT 5m
  MAXSIZE 20M;
  

ALTER TABLESPACE GAE_QDATA online;



ALTER USER GAECORE QUOTA 2M ON GAE_QDATA;

CREATE TABLE table1 (c NUMBER);

INSERT INTO table1(c) VALUES(3);
INSERT INTO table1(c) VALUES(1);
INSERT INTO table1(c) VALUES(2);

SELECT * FROM table1;

DROP TABLE table1;
