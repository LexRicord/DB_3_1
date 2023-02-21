--                  TASK 1
C:\ Oracle_setup\WINDOWS.X64_193000_db_home\network\admin\SQLNET.ORA (tnsnames.ora)

--                  TASK 2
--system Password -> select * from v$parameter;

--                  TASK 3
--system/password @localhost:1521/pdb_1
select * from user_tablespaces;
select name from v$datafile;
select * from dba_roles;
select * from dba_users;


--                  TASK 5
--U1_GAE_PDB_GAE_PDB =
--U1_GAE_PDB/12345@(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521)) (CONNECT_DATA = (SERVICE_NAME = pdb_1)))


--                  TASK 6
--U1_GAE_PDB/12345@(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521)) (CONNECT_DATA = (SERVICE_NAME = pdb_1)))

--                  TASK 7
select TABLE_NAME from user_tables;
select * from U1GAETABLE;


--                  TASK 8
SET TIMING ON
select * from U1GAETABLE;

--                  TASK 9
DESCRIBE U1_GAE_PDB.U1GAETABLE.ID

--                  TASK 10
select segment_name from user_segments;

--                  TASK 11
-- sys as sysdba
CREATE view ALLEX as select count(SEGMENT_NAME) as  "КОЛ-ВО СЕГМЕНТОВ",
       SUM(EXTENTS) as  "КОЛ-ВО ЭКСТЕНТОВ",
       SUM(BLOCKS)  as  "КОЛ-ВО БЛОКОВ", 
       SUM(BYTES)  as  "КОЛ-ВО БАЙТ"
from dba_segments;
select * from ALLEX;