ALTER USER GAE_1 quota unlimited on users;
--            TASK 1
create table Lab18_table(
id number(15) PRIMARY KEY,
text varchar2(20),
date_value date)
tablespace users;

DROP TABLE Lab18_table;

SELECT * FROM Lab18_table;

SET SERVEROUTPUT ON FORMAT WRAPPED
SET VERIFY OFF

SET FEEDBACK OFF
SET TERMOUT OFF
--GAE_1/12345@//localhost:1522/pdb1
spool D:\repos\DB_3_1\db_18\export.txt;
ALTER SESSION SET nls_date_format='dd-mm-yyyy hh24:mi:ss';
select sysdate as "ExportDate" from dual;
select * from Lab18_table; 
spool off;
