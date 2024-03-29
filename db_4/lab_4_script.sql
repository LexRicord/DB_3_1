ALTER DATABASE OPEN;
--              TASK 1
select name,open_mode from v$pdbs; 

--              TASK 2 
select INSTANCE_NAME from v$instance;

--              TASK 3
select * from PRODUCT_COMPONENT_VERSION;

--              TASK 4 
--В VM в DATABASE CONFIGURATION ASSISTANT;

--              TASK 5 
select name,open_mode from v$pdbs;

--              TASK 6 
CREATE TABLESPACE TS_GAE
DATAFILE 'C:\Oracle_setup\app\Tablespaces\GAE_PDB\TS_GAE.dbf' 
size 7M
REUSE AUTOEXTEND ON NEXT 5M 
MAXSIZE 20M
LOGGING
ONLINE;
commit;
DROP TABLESPACE TS_GAE INCLUDING CONTENTS AND DATAFILES;

select TABLESPACE_NAME, BLOCK_SIZE, MAX_SIZE from sys.dba_tablespaces order by tablespace_name;

CREATE TEMPORARY TABLESPACE TS_GAE_TEMP
TEMPFILE 'C:\Oracle_setup\Tablespaces\GAE_PDB\TS_GAE_TEMP.dbf' size 5M
REUSE AUTOEXTEND ON NEXT 3M 
MAXSIZE 30M;
commit;

DROP TABLESPACE TS_GAE_TEMP_1 INCLUDING CONTENTS AND DATAFILES;

create role RL_GAE;
commit;

drop role RL_GAE;

grant create session, create any table, create any view, create any procedure, ALTER ANY SEQUENCE,CREATE SEQUENCE  to RL_GAE;
grant  create  view to RL_GAE;
grant drop any table, drop any view, drop any procedure to RL_GAE;
commit;


create profile PF_GAE limit
password_life_time 180 -- кол-во дней жизни пароля
sessions_per_user 3 -- кол-во сессий для пользователя
FAILED_LOGIN_ATTEMPTS 7 -- кол-во попыток входа
PASSWORD_LOCK_TIME 1 -- кол-во дней блокировки после ошибки
PASSWORD_Reuse_time 10 -- через сколько дней можно повторить пароль
password_grace_time default -- кол-во дней предупреждения о смене пароля
connect_time 180 -- время соединения
idle_time 30; -- простой
commit;

drop profile PF_GAE;

create user U1_GAE_PDB identified by 12345
default tablespace TS_GAE quota unlimited on TS_GAE
profile PF_GAE
account unlock;

drop user U1_GAE_PDB CASCADE;

grant RL_GAE to U1_GAE_PDB;
commit;

select * from DBA_SYS_PRIVS where GRANTEE = 'U1_GAE_PDB';
select * from DBA_ROLE_PRIVS where GRANTEE = 'U1_GAE_PDB';
select GRANTEE, PRIVILEGE from DBA_SYS_PRIVS where GRANTEE='U1_GAE_PDB'; 

commit;

--              TASK 7 
DROP table U1GAETABLE

CREATE TABLE U1GAETABLE(
id number GENERATED ALWAYS AS IDENTITY primary key,
word varchar2(50)
);

INSERT into U1GAETABLE(word) values('CHANGED');
INSERT into U1GAETABLE(word) values('a');
INSERT into U1GAETABLE(word) values('b');
commit;
SELECT * FROM U1GAETABLE;
--              TASK 8
select * from DBA_USERS; 
select * from DBA_TABLESPACES; 
select * from DBA_DATA_FILES;   
select * from DBA_TEMP_FILES;  
select * from DBA_ROLES;
select * from DBA_ROLE_PRIVS where GRANTED_ROLE = 'RL_GAE';
select * from DBA_ROLE_PRIVS where GRANTED_ROLE = 'C##GAE_ROLE';
select * from DBA_ROLE_PRIVS where GRANTEE = 'C##GAE';
select * from DBA_ROLE_PRIVS t1 inner join DBA_SYS_PRIVS t2 on t1.GRANTED_ROLE = t2.GRANTEE where t1.GRANTEE='U1_GAE_PDB'; 
select * from DBA_PROFILES; 
--              TASK 9

create user C##GAE identified by 1234
account unlock;

--              TASK 10
conn / as SYSDBA;

CREATE ROLE C##GAE_ROLE;

grant create session, create any table, create any view, create any procedure, ALTER ANY SEQUENCE,CREATE SEQUENCE  to C##GAE_ROLE;
grant  create  view to C##GAE_ROLE;
grant drop any table, drop any view, drop any procedure to C##GAE_ROLE;
commit;


select * from v$session where USERNAME is not null;

select PRIVILEGE from USER_SYS_PRIVS; 