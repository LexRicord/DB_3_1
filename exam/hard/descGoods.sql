create or replace procedure descGoods(in_year in orders.order_date%type)
is 
cursor curs is 
select products.product_id,products.MFR_ID,products.qty_on_hand from PRODUCTS
left outer join orders on PRODUCTS.MFR_ID != ORDERS.MFR and PRODUCTS.PRODUCT_ID != ORDERS.PRODUCT
group by products.product_id, products.MFR_ID,products.qty_on_hand
order by products.qty_on_hand desc;
year_str varchar2(20);
check_exists number;
invaliddata exception;
no_year exception;
cur_type curs%rowtype;
begin
if in_year is null then raise invaliddata;
end if;
year_str := to_char(in_year,'YYYY');
select count(*) into check_exists from orders 
where to_char(orders.order_date,'YYYY') = year_str;
if check_exists = 0 then raise no_year;
end if;
open curs;
loop 
fetch curs into cur_type;
exit when curs%notfound;
dbms_output.put_line('MFR Продукта: | '||cur_type.mfr_id||' | ID-Продукта: | '||cur_type.product_id||' | Продуктов на складе: |'||cur_type.qty_on_hand);
end loop;
exception 
when invaliddata then
raise_application_error(-20001,'Введенное значение равно NULL.');
when no_year then
raise_application_error(-20002,'В таблице ORDERS нет заказов с таким годом.');
end;

declare
    d date := '2008-02-20';
    d2 varchar2(20);
begin
    d2 := to_char(d,'YYYY');
    descGoods(d);
end;