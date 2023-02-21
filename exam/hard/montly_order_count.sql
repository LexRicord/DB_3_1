create or replace package EXAM_1 as
type out_type is record(ord_month varchar2(25),
order_count NUMBER
);
type t_out_type is table of out_type;
cursor MyCurr return out_type is
select to_char(ORDER_DATE,'MONTH'),
       count(orders.order_num)
from orders join customers
on orders.cust = customers.cust_num where customers.cust_num = 2103
group by to_char(ORDER_DATE,'MONTH');

function cust_orders_for_month(cust_id customers.cust_num%type,
start_date orders.ORDER_DATE%type,
end_date orders.ORDER_DATE%type) 
RETURN t_out_type PIPELINED;

wrong_date EXCEPTION;
no_customers EXCEPTION;
end EXAM_1;

create or replace package body EXAM_1 as
function cust_orders_for_month(cust_id customers.cust_num%type,
start_date orders.ORDER_DATE%type,
end_date orders.ORDER_DATE%type) 
return t_out_type pipelined
is
t_out out_type;
c number;
begin
    if start_date >= end_date then raise wrong_date;
    end if;
    select count(*) into c from CUSTOMERS where CUSTOMERS.CUST_NUM = cust_id;
    if c < 1 then raise no_customers;
    end if;
    open MyCurr;
    loop
        fetch MyCurr into t_out;
        exit when MyCurr%notfound;
        PIPE ROW(t_out);
    end loop;
    close MyCurr;
exception
when wrong_date then
        raise_application_error(-20001, 'Parameter 1 more or equal to Parameter 2');
when no_customers then
        raise_application_error(-20002, 'No such office');
end cust_orders_for_month;
end EXAM_1;

select * from table(EXAM_1.cust_orders_for_month(2103,'17.12.06','17.12.09'));