select * from DBA_DB_LINKS;
select * from user_db_links;
select * from global_name;

grant connect to GAE_1 identified by 12345;
create view VVV as select * from tab@GAE_LINK;
grant select on VVV to GAE_1 with grant option;
grant select on VVV to GAE_1;
--            TASK 1
CREATE DATABASE LINK GAE_LINK
   CONNECT TO GAE
   IDENTIFIED BY "12345"
   USING 'WIN-DARLV66992B:1521/pdb1';
   
   DROP DATABASE LINK GAE_LINK;

ALTER SESSION CLOSE DATABASE LINK GAE_LINK;
DROP DATABASE LINK GAE_LINK;

--            TASK 2
SELECT * FROM lab18@lke_link;
INSERT INTO lab18@lke_link values(21,'123','01.01.2002');
DELETE lab18@lke_link where id='21';

--            TASK 3
   CREATE PUBLIC DATABASE LINK GAE_LINK_PUBLIC 
   CONNECT TO GAE
   IDENTIFIED BY "12345"
   USING 'WIN-DARLV66992B:1521/pdb1';
   
ALTER SESSION CLOSE DATABASE LINK GAE_LINK_PUBLIC;
DROP PUBLIC DATABASE LINK GAE_LINK_PUBLIC;


--            TASK 4

select * from DBA_DB_LINKS;
DROP PUBLIC DATABASE LINK GAE_LINK_PUBLIC;

SELECT * FROM names@GAE_LINK_PUBLIC;
INSERT INTO names@GAE_LINK_PUBLIC values(4,'123');
DELETE names@GAE_LINK_PUBLIC where name='12';