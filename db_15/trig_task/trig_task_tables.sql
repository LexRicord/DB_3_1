create table ListOfGoods
(
Id INTEGER GENERATED ALWAYS AS IDENTITY
(START WITH 1 INCREMENT BY 1) primary key,
CodeOfGood INTEGER,
ProducerCode nvarchar2(10) NOT NULL,
Model nvarchar2(50) NOT NULL,
Price int not null,
DeleteState number(1,0) default 0 not null,
DeleteDate DATE,
UpdateState number(1,0) default 0 not null,
CONSTRAINT check_delete_state
CHECK (DeleteState = 0 or DeleteState = 1),
CONSTRAINT check_update_state
CHECK (UpdateState = 0 or UpdateState = 1)
);
alter table LISTOFGOODS add (UpdateDate DATE);


ALTER SESSION SET nls_date_format='dd-mm-yyyy hh24:mi:ss';
select object_name, status from user_objects where object_type='TRIGGER'
and OBJECT_NAME = 'CMP_TRIG';
alter table LISTOFGOODS enable all triggers;

insert into ListOfGoods(CodeOfGood, ProducerCode, Model, Price)
values(1,'Acer','Aspire A315-21G-955U',1599);

insert into ListOfGoods(CodeOfGood, ProducerCode, Model, Price)
values(2,'Apple','MacBook Air 14',2699);

select * from ListOfGoods order by ListOfGoods.CODEOFGOOD asc;

delete from ListOfGoods where ListOfGoods.CODEOFGOOD = 1;

update LISTOFGOODS set MODEL = 'MacBook Air 17'
                   where ListOfGoods.CODEOFGOOD = 2;

delete from ListOfGoods where ListOfGoods.MODEL = 'MacBook Air 11';