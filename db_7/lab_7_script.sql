--                  TASK 1
select name, description from v$bgprocess order by 1;

--                  TASK 2
SELECT * FROM v$process; 

--                  TASK 3
show parameter db_writer_processes;

--                  TASK 4-5
select * from v$instance;

--                  TASK 6
select * from v$services;

--                  TASK 7
select * from V$DISPATCHER;
show  parameter DISPATCHERS

--                  TASK 9
select username, server from v$session;

--                  TASK 10
--С:\Oracle_setup\WINDOWS.X64_193000_db_home\network\admin

--                  TASK 11
-- sqlPlus -> lsnrctl -> help

--                  TASK 12
select TYPE, NAME, NETWORK_NAME, PDB from v$listener_network inner join V$SERVICES on v$listener_network.value = V$SERVICES.name;