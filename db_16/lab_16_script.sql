ALTER SESSION SET nls_date_format='dd-mm-yyyy hh24:mi:ss';

GRANT CREATE TABLESPACE TO GAE;
ALTER USER GAE QUOTA UNLIMITED ON tb1;
ALTER USER GAE QUOTA UNLIMITED ON tb2;
ALTER USER GAE QUOTA UNLIMITED ON tb3;
ALTER USER GAE QUOTA UNLIMITED ON tb4;
GRANT ALTER TABLESPACE TO GAE;

CREATE TABLESPACE tb1 DATAFILE 'C:\Oracle_setup\app\Tablespaces\GAE_PDB\tb1.DBF'
  SIZE 10M REUSE AUTOEXTEND ON NEXT 2M MAXSIZE 500M;
CREATE TABLESPACE tb2 DATAFILE 'C:\Oracle_setup\app\Tablespaces\GAE_PDB\tb2.DBF'
  SIZE 10M REUSE AUTOEXTEND ON NEXT 2M MAXSIZE 500M;  
CREATE TABLESPACE tb3 DATAFILE 'C:\Oracle_setup\app\Tablespaces\GAE_PDB\tb3.DBF'
  SIZE 10M REUSE AUTOEXTEND ON NEXT 2M MAXSIZE 500M;  
CREATE TABLESPACE tb4 DATAFILE 'C:\Oracle_setup\app\Tablespaces\GAE_PDB\tb4.DBF'
  SIZE 10M REUSE AUTOEXTEND ON NEXT 2M MAXSIZE 500M;

select * from DBA_TABLES where owner = 'GAE' and partitioned = 'YES';
select * from user_tablespaces;
select * from user_tables;
select * from DBA_TAB_PARTITIONS where table_owner = 'GAE'; 
select * from user_part_tables;
select * from DBA_TAB_SUBPARTITIONS;
select * from user_objects where object_type = 'TABLE PARTITION';
select distinct OBJECT_NAME from user_objects where object_type = 'TABLE PARTITION';
select * from user_segments where PARTITION_NAME is not null;
select * from user_part_key_columns;
  
DROP TABLESPACE tb1 INCLUDING CONTENTS AND DATAFILES; 
DROP TABLESPACE tb2 INCLUDING CONTENTS AND DATAFILES; 
DROP TABLESPACE tb3 INCLUDING CONTENTS AND DATAFILES; 
DROP TABLESPACE tb4 INCLUDING CONTENTS AND DATAFILES; 
--            TASK 1
create table T_Range(id number primary key,
time_id date)
partition by range(id)
(
Partition part1 values less than (100) tablespace tb1,
Partition part2 values less than (200) tablespace tb2,
Partition part3 values less than (300) tablespace tb3,
Partition partmax values less than (maxvalue) tablespace tb4
);

insert into T_Range(id, time_id) values(75,'11-03-2008');
insert into T_Range(id, time_id) values(105,'01-01-2009');
insert into T_Range(id, time_id) values(110,'01-01-2014');
insert into T_Range(id, time_id) values(205,'01-01-2015');
insert into T_Range(id, time_id) values(305,'01-01-2016');
insert into T_Range(id, time_id) values(405,'01-01-2018');
insert into T_Range(id, time_id) values(505,'01-01-2019');

select * from T_range partition(part1);
select * from T_range partition(part2);
select * from T_range partition(part3);
select * from T_range partition(partmax);
drop table T_RANGE;

--            TASK 2
create table T_Interval(id number, time_id date) partition by range(time_id)
interval (numtoyminterval(1,'month'))
(
partition part0 values less than  (to_date ('1-12-2009', 'dd-mm-yyyy')),
partition part1 values less than  (to_date ('1-12-2015', 'dd-mm-yyyy')),
partition part2 values less than  (to_date ('1-12-2018', 'dd-mm-yyyy'))
);

insert into T_Interval(id, time_id) values(50,'11-03-2008');
insert into T_Interval(id, time_id) values(105,'01-01-2009');
insert into T_Interval(id, time_id) values(105,'01-01-2014');
insert into T_Interval(id, time_id) values(205,'01-01-2015');
insert into T_Interval(id, time_id) values(305,'01-01-2016');
insert into T_Interval(id, time_id) values(405,'01-01-2018');
insert into T_Interval(id, time_id) values(505,'01-01-2019');

select * from T_Interval partition(part0);
select * from T_Interval partition(part1);
select * from T_Interval partition(part2);

--            TASK 3
create table T_hash (
str varchar2 (50), 
id number
) partition by hash (str)
(
partition key1 tablespace tb1,
partition key2 tablespace tb2,
partition key3 tablespace tb3,
partition key4 tablespace tb4
);

insert into T_hash (str,id) values('abcdefg', 1);
insert into T_hash (str,id) values('qwertyuio', 2);
insert into T_hash (str,id) values('?/?./././', 3);
insert into T_hash (str,id) values('asdfghjk', 4);
insert into T_hash (str,id) values('+-/*', 5);
insert into T_hash (str,id) values('123456', 6);
insert into T_hash (str,id) values('4', 7);

select * from T_hash partition(key1);
select * from T_hash partition(key2);
select * from T_hash partition(key3);
select * from T_hash partition(key4);

create table T_hash2 (
str varchar2 (50), 
id number
) partition by hash (str)
Partitions 4 store in
(
tb1, tb2, tb3, tb4
);
insert into T_hash2 (str,id) values('abcdefg', 1);
insert into T_hash2 (str,id) values('qwertyuio', 2);
insert into T_hash2 (str,id) values('?/?./././', 3);
insert into T_hash2 (str,id) values('asdfghjk', 4);
insert into T_hash2 (str,id) values('+-/*', 5);
insert into T_hash2 (str,id) values('123456', 6);
insert into T_hash2 (str,id) values('4', 7);

drop table T_hash2;
select * from user_objects where object_type = 'TABLE PARTITION'
and object_name = 'T_HASH2';
select * from T_hash2 partition(SYS_P389);


--            TASK 4
create table T_list(obj char(3)) partition by list (obj)
(
partition part1 values ('a','d') tablespace tb1,
partition part2 values ('b'),
partition part3 values ('c')
);

insert into  T_list(obj) values('a');
insert into  T_list(obj) values('b');
insert into  T_list(obj) values('c');
insert into  T_list(obj) values('d');
insert into  T_list(obj) values('e');

select * from T_list partition (part1);
select * from T_list partition (part2);
select * from T_list partition (part3);

--            TASK 6
alter table T_list enable row movement;
update T_list set obj='a' where obj='b';

--            TASK 7
alter table T_Range merge partitions part1,part2 into partition part5;
select * from T_range partition(part5);

--            TASK 8
alter table t_interval split partition part2 at (to_date ('1-06-2018', 'dd-mm-yyyy')) 
into (partition part6 tablespace tb4, partition part5 tablespace tb2);

select * from t_interval partition(part5);
select * from t_interval partition(part6);

--            TASK 9
create table T_list1(obj char(3));
alter table T_list exchange partition part3 with table T_list1 without validation;
select * from T_list partition (part3);
select * from T_list1;

--▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
drop table T_RANGE;
drop table T_INTERVAL;
drop table T_HASH;
drop table T_LIST;
drop table T_LIST1;
