create table T_Interval_2(int_id number not null,
time_id date not null,
CONSTRAINT t_range_fk FOREIGN KEY (int_id) REFERENCES T_RANGE(ID)) partition by reference (t_range_fk);

alter table T_INTERVAL_2 disable row movement;

drop table T_INTERVAL_2;

insert into T_Interval_2(int_id, time_id) values(75,'11-03-2008');
insert into T_Interval_2(int_id, time_id) values(105,'01-01-2009');
insert into T_Interval_2(int_id, time_id) values(110,'01-01-2014');
insert into T_Interval_2(int_id, time_id) values(205,'01-01-2015');
insert into T_Interval_2(int_id, time_id) values(305,'01-01-2016');
insert into T_Interval_2(int_id, time_id) values(405,'01-01-2018');
insert into T_Interval_2(int_id, time_id) values(505,'01-01-2019');

select TABLE_NAME, PARTITION_NAME,HIGH_VALUE from user_tab_partitions
where table_name = 'T_RANGE';
select TABLE_NAME, PARTITION_NAME,HIGH_VALUE from user_tab_partitions
where table_name = 'T_INTERVAL_2';
select * from USER_TAB_PARTITIONS;

select * from T_Interval_2 partition(part1);
select * from T_Interval_2 partition(part2);
select * from T_Interval_2 partition(part3);
select * from T_Interval_2 partition(partmax);