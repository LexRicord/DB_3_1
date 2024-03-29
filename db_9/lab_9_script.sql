SELECT NAME, FIRST_CHANGE#, NEXT_CHANGE# FROM V$ARCHIVED_LOG;
SELECT * FROM V$ARCHIVED_LOG;

--            TASK 1
grant create session to GAE;
grant create table to GAE;
grant create view to GAE;
grant create any sequence to GAE;
grant select any sequence to GAE;
grant create cluster to GAE;
grant create public synonym to GAE;
grant create synonym to GAE;
grant create materialized view to GAE;
grant drop public synonym to GAE;
alter user GAE quota unlimited on users;

--            TASK 2

create sequence GAE.S1
    increment by 10
    start with 1000
    nomaxvalue
    nominvalue
    nocycle
    nocache
    noorder;
  
select S1.nextval from dual;   
select S1.currval from dual;

DROP sequence S1;

--            TASK 3

create sequence GAE.S2
    increment by 10
    start with 10
    maxvalue 100
    nocycle;

select S2.nextval from dual;   
alter sequence S2 increment by 90;
select S2.currval from dual;

DROP sequence S2;

--            TASK 5
create sequence GAE.S3
    increment by -10
    start with 10
    maxvalue 20
    minvalue -100
    nocycle
    order;

select S3.nextval from dual;

alter sequence S3 increment by -90;
select S3.nextval from dual;  

alter sequence S3 increment by -10;  

DROP sequence S3;

--            TASK 6
create sequence GAE.S4
    increment by 1
    start with 1
    maxvalue 4
    cycle
    cache 2
    noorder;
    
select S4.nextval from dual;

DROP sequence S4;


--            TASK 7
select * from sys.all_sequences where sequence_owner='GAE';

--            TASK 8
select * from user_tablespaces;
create table T1 (
    N1 number(20),
    N2 number(20),
    N3 number(20),
    N4 number(20)
    ) tablespace USERS;
    
alter table T1 cache storage (buffer_pool keep);

BEGIN
      FOR i IN 1..7 LOOP
      insert into T1(N1,N2,N3,N4) values (S1.currval, S2.currval, S3.currval, S4.currval);
      END LOOP;
END;

select * from T1;

--            TASK 9
create cluster GAE.ABC
(
    x number(10),
    v varchar2(12)
)
hashkeys 200 tablespace USERS;

--            TASK 10-12
create table A(XA number(10), VA varchar(12), CA char(10))  cluster GAE.ABC(XA,VA);
create table B(XB number(10), VB varchar(12), CB char(10)) cluster GAE.ABC(XB,VB);
create table C(XC number(10), VC varchar(12), CC char(10))  cluster GAE.ABC(XC,VC) ;

--            TASK 13 
select cluster_name, owner from DBA_CLUSTERS;
select * from dba_tables where cluster_name='ABC';    

--            TASK 14-15
create synonym SS1 for GAE.C;
create public synonym SS for GAE.B;

select * from ALL_SYNONYMS where table_owner='GAE';

DROP SYNONYM SS1;
DROP PUBLIC SYNONYM SS2;
DROP TABLE A;
DROP TABLE B;
DROP TABLE C;


--            TAST 16
create table A (
    X number(20) primary key
);

create table B (
    Y number(20),
    constraint fk_column
    foreign key (Y) references A(X)
);
drop table b;
insert into A(X) values (1);
insert into A(X) values (2);
insert into B(Y) values (1);
insert into B(Y) values (2);
    
create view V1 as select X, Y from A inner join B on A.X=B.Y;
    
select * from V1;

DROP VIEW V1;

--            TAST 17
create materialized view MV
    build immediate
    refresh complete
    start with sysdate
    next sysdate + Interval '1' minute
    as
    select A.X, B.Y
    from (select count(*) X from A) a,
         (select count(*) Y from B) b;
    
    select * from MV;
    insert into A(X) values (8);
    
drop materialized view MV;
------------------------
select * from user_objects;

-- -20001 and -20999.
declare
        ex_custom EXCEPTION;
        PRAGMA EXCEPTION_INIT( ex_custom, -20001 );
    begin
        raise_application_error( -20001, 'Custom(user) error' );
    exception
        when ex_custom
    then
        dbms_output.put_line( sqlerrm );
end;