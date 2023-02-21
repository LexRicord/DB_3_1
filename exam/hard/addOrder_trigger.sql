create or replace procedure addOrder(or_num in orders.order_num%type,
or_date orders.order_date%type, or_cust orders.cust%type,
or_rep orders.rep%type, or_mfr orders.mfr%type,
or_product orders.product%type,
or_qty orders.QTY%type, or_amount orders.amount%type)
is
date_range exception;
no_cust exception;
no_salesrep exception;
no_office exception;
no_product exception;
check_cust number;
check_salesrep number;
check_mfr number;
check_product number;
check_date date := '2008-01-01';
begin
if (or_date > sysdate or or_date < check_date) then raise date_range;
end if;
select count(*) into check_cust from customers where CUSTOMERS.CUST_NUM = or_cust;
if check_cust = 0 then raise no_cust;
end if;

select count(*) into check_salesrep from salesreps s where s.empl_num = or_rep;
if check_salesrep = 0 then raise no_salesrep;
end if;

select count(*) into check_mfr from products p where p.mfr_id = or_mfr;
if check_mfr = 0 then raise no_office;
end if;

select count(*) into check_product from products p where p.product_id = or_product;
if check_product = 0 then raise no_product;
end if;

insert into orders(order_num,order_date, cust, rep, mfr, product, qty, amount)
values (or_num, or_date, or_cust, or_rep, or_mfr, or_product, or_qty, or_amount);
exception
    when date_range then
    raise_application_error(-20001, 'Дата выходит за допустимый диапазон {01.01.2008, sysdate}');
    when no_cust then
    raise_application_error(-20002, 'Такого покупателя не существует');
    when no_salesrep then
    raise_application_error(-20003, 'Такого продавца не существует');
    when no_office then
    raise_application_error(-20004, 'Такого офиса не существует');
    when no_product then
    raise_application_error(-20005, 'Такого продукта не существует');
  commit;
end;

------
declare
    d date := '2009-02-20';
begin
addOrder(113045,d,2113,101,'REI','2A44R',5,22500.00);
end;
alter session set nls_date_format = 'YYYY-MM-DD';
select * from ORDERS where order_num = 113043;
----

alter table orders enable all triggers;

CREATE OR REPLACE TRIGGER INSERTORDERTRIGGER
BEFORE INSERT ON ORDERS
for each ROW
declare
check_exists number;
order_exists exception;
BEGIN
    select count(*) into check_exists from orders
    where order_num = :new.order_num and order_date = :new.order_date
    and cust = :new.cust and rep = :new.rep
    and mfr = :new.mfr and product = :new.product;
    if check_exists > 0 then raise order_exists;
    end if;
EXCEPTION
    when order_exists then
    raise_application_error(-20006,'Такой заказ уже существует');
END;