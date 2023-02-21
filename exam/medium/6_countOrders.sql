create or replace function countOrders(start_date orders.order_date%type,
end_date orders.order_date%type) return number 
is
countOrders number;
begin
    select sum(orders.qty) into countOrders from orders
    where order_date >= start_date and order_date <= end_date;
    return countOrders;
end;

select countOrders('01.01.08','03.01.09') from dual;
select order_date,countOrders(order_date,order_date+100) from orders;