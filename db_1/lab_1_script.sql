--task9
CREATE TABLE GAE_t 
(
    x NUMBER(3),
    s VARCHAR2(50)
);

--task11
INSERT INTO GAE_t (x, s) VALUES (1, 'First');
INSERT INTO GAE_t (x, s) VALUES (2, 'Second');
INSERT INTO GAE_t (x, s) VALUES (3, 'Third');
commit;

-task12
update GAE_t SET s = 'Updated Second' where x = 2;
update GAE_t SET s = 'Updated Third' where x = 3;
commit;

-task13
select from * GAE_t where x > 1;
select count(*) from GAE_t where x > 1;

--task14
delete from GAE_t where x = 1;
commit;

--task15
create table GAE_t1 (
    id number(3) PRIMARY KEY,
    gaeId number(3),
    s varchar2(50),
    CONSTRAINT fk_gae FOREIGN KEY (gae_id) REFERENCES GAE_t(x)
);
insert into XXX_t1 (id, gae_id, s) values (1, 2, 'Add. data');
insert into XXX_t1 (id, gae_id, s) values (2, 3, 'Add. data');

--task16
select * from GAE_t
left join GAE_t1 on GAE_t.x = GAE_t1.gae_id;

select * from GAE_t
right join GAE_t1 on GAE_t.x = GAE_t1.gae_id;

select * from GAE_t
inner join GAE_t1 on GAE_t.x = GAE_t1.gae_id;

--task18 
drop table GAE_t1;
drop table GAE_t;
