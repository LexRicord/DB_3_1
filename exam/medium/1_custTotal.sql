create or replace procedure custTotal(in_name customers.company%type)
is 
cursor curs 
is select orders.order_num, orders.amount,customers.company from orders
join customers on orders.cust = customers.cust_num
group by orders.order_num,orders.amount,customers.company;
check_name number;
invaliddata exception;
no_customer exception;
too_many_names exception;
cur_type curs%rowtype;
cust_name CUSTOMERS.company%type;
begin
    if in_name is null then raise invaliddata;
    end if;
    SELECT count(*) into check_name FROM CUSTOMERS WHERE INSTR(CUSTOMERS.company, in_name) > 0;
    if check_name = 0 then raise no_customer;
    elsif check_name > 1 then raise too_many_names;
    end if;
    SELECT CUSTOMERS.company into cust_name FROM CUSTOMERS WHERE INSTR(CUSTOMERS.company, in_name) > 0;
    open curs;
    loop
        fetch curs into cur_type;
        exit when curs%notfound;
        if(cur_type.company = cust_name) then
        dbms_output.put_line('Номер заказа: | '||cur_type.order_num||' | Итоговая стоимость заказа: | '||cur_type.amount);
        end if;
    end loop;
    close curs;
exception 
    when invaliddata then
    raise_application_error(-20001,'Имя не может быть NULL.');
    when no_customer then
    raise_application_error(-20002,'Кастомера с таким именем не существует.');
    when too_many_names then
    raise_application_error(-20003,'Слишком много кастомеров найдено, уточните имя.');
end;