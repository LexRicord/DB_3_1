-- написать compound триггер : soft delete, soft update. Есть таблица 
ALTER SESSION SET nls_date_format='dd-mm-yyyy hh24:mi:ss';
grant create any trigger to GAE;
GRANT ADMINISTER DATABASE TRIGGER TO GAE;
select * from user_sys_privs;
select object_name, status from user_objects where object_type='TRIGGER';
--            TASK 1
create table Names
(
id number, 
name varchar2(100) not null unique,
constraint id_pk primary key(id)
);
alter table Names enable all triggers;
drop table Names;
--            TASK 2
declare
  x number(10):= 0;
  string varchar(20);
begin
  while(x<10)
    loop
      x:= x+1;
      string:= concat('Name',to_char(x));
      insert into Names(id,name) values(x,string);
    end loop;
  commit;
end;
select * from Names;

--            TASK 3-4
select * from user_sys_privs;
create or replace trigger beforeInsertTrigger
before insert on Names
begin
  dbms_output.put_line('Before insert');
end;

create or replace trigger beforeDeleteTrigger
before delete on Names
begin 
  dbms_output.put_line('Before delete'); 
end;

create or replace trigger beforeUpdateTrigger
before update on Names
begin 
  dbms_output.put_line('Before update'); 
end;

insert into Names (id, name) values(20, 'insert');
update Names set name = 'update' where id = 20;
delete from Names where id = 20;

select * from Names;

--            TASK 5
create or replace trigger beforeInsertRowTrigger
before insert on Names for each row
begin 
  dbms_output.put_line('Before insert row'); 
end;

create or replace trigger beforeDeleteRowTrigger
before delete on Names for each row
begin 
  dbms_output.put_line('Before delete row'); 
end;

create or replace trigger beforeUpdateRowTrigger
before update on Names for each row
begin 
  dbms_output.put_line('Before update row'); 
end;

--            TASK 6
create or replace trigger predicates
after insert or update or delete on Names
begin 
    if INSERTING then
        dbms_output.put_line('Inserting after');
    elsif UPDATING then
        dbms_output.put_line('Updating after');
    elsif DELETING then
        dbms_output.put_line('Deleting after');
    end if;
end; 

--            TASK 7
create or replace trigger afterInsertTrigger
after insert on Names
begin 
  dbms_output.put_line('After insert'); 
end;

create or replace trigger afterDeleteTrigger
after delete on Names
begin 
  dbms_output.put_line('After delete'); 
end;

create or replace trigger afterUpdateTrigger
after update on Names
begin 
  dbms_output.put_line('After update'); 
end;
    
--            TASK 8
create or replace trigger afterInsertRowTrigger
after insert on Names for each row
begin 
  dbms_output.put_line('After insert row'); 
end;

create or replace trigger afterDeleteRowTrigger
after delete on Names for each row
begin 
  dbms_output.put_line('After delete row'); 
end;

create or replace trigger afterUpdateRowTrigger
after update on Names for each row
begin 
  dbms_output.put_line('After update row'); 
end;
    
--            TASK 9
create table TRIGS
(
OperationDate date,
OperationType varchar2(40), 
TriggerName varchar2(40),
Data varchar2(40) 
);
--            TASK 10        
create or replace trigger beforeTriggersTrigs
before insert or update or delete on Names
begin
   if inserting then
        dbms_output.put_line('before insert TRIGS');
        insert into TRIGS(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Insert', 'before insert TRIGS',concat(id, name)
        from Names;
   elsif updating then
        dbms_output.put_line('before update TRIGS');
        insert into TRIGS(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Update', 'before update TRIGS',concat(id, name)
        from Names;
  elsif deleting then
        dbms_output.put_line('before delete TRIGS');
        insert into TRIGS(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Delete', 'before delete TRIGS',concat(id, name)
        from Names;
  end if;
end;

create or replace trigger afterTriggersTrigs
after insert or update or delete on Names
begin
   if inserting then
        dbms_output.put_line('after insert TRIGS');
        insert into TRIGS(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Insert', 'after insert TRIGS',concat(id, name)
        from Names;
   elsif updating then
        dbms_output.put_line('after update TRIGS');
        insert into TRIGS(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Update', 'after update TRIGS',concat(id, name)
        from Names;
  elsif deleting then
        dbms_output.put_line('after delete TRIGS');
        insert into TRIGS(OperationDate, OperationType, TriggerName, Data)
        select sysdate,'Delete', 'after delete TRIGS',concat(id, name)
        from Names;
  end if;
end;

------------------------------------------------
SELECT * from Names;
SELECT * from TRIGS;
select object_name, status from user_objects where object_type='TRIGGER';
--            TASK 11
insert into Names (id, name) values(2, 'error');
select * from TRIGS;

--            TASK 12
drop table Names;
select * from Names;

ALTER SESSION SET recyclebin= ON;
--SELECT * FROM DBA_RECYCLEBIN;
FLASHBACK table Names TO BEFORE DROP;

create table trigs_for_db
(
ora_event nvarchar2(50),
ora_obj_owner nvarchar2(50),
ora_obj_name nvarchar2(50),
ora_obj_type nvarchar2(50),
ora_context nvarchar2(50),
date_time date
);

select * from trigs_for_db;

create or replace trigger noDropTable
before drop on GAE.schema
begin
   if (DICTIONARY_OBJ_NAME = 'Names' and ORA_DICT_OBJ_OWNER = 'GAE')
   then
        RAISE_APPLICATION_ERROR (-20000, 'Do not drop table '||ORA_DICT_OBJ_TYPE||' '||ORA_DICT_OBJ_NAME);
   end if;
end; 
commit;

CREATE OR REPLACE TRIGGER DROPPING_TABLE
BEFORE DROP
ON database
declare
   PRAGMA AUTONOMOUS_TRANSACTION;
begin
  insert into trigs_for_db
  VALUES( SUBSTR(ora_sysevent,1,50),
          SUBSTR(ora_dict_obj_owner,1,50),
          SUBSTR(ora_dict_obj_name,1,50),
          SUBSTR(ora_dict_obj_TYPE,1,50),
          UPPER(sys_context('USERENV','TERMINAL')),
          SYSDATE
        );
  commit;

  if SUBSTR(ora_dict_obj_name,1,50) in     
           ('Names','Trigs','trigs_for_db')
  then
    begin
      RAISE_APPLICATION_ERROR(num => -20998, 
                        msg => 'Stop deleting my table, whoever you are'); 
    end;
  end if;
end;
--            TASK 13
drop table TRIGS;
FLASHBACK table TRIGS TO BEFORE DROP;
--            TASK 14

create or replace view Namesview as SELECT * FROM Names;
    
CREATE OR REPLACE TRIGGER name_trigg
instead of insert on Namesview
    BEGIN
        if inserting then
            dbms_output.put_line('insert');
            insert into Names VALUES (102, 'bye');
        end if;
END name_trigg;
      
INSERT INTO Namesview (id,name) values(12,'c');
SELECT * FROM Namesview;

--            TASK 15
select * from TRIGS;