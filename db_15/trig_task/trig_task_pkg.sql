create or replace PACKAGE DB_CMP_TRIG AS
    type t_listofgoods is table of ListOfGoods%rowtype index by pls_integer;
    type t_audit is table of AuditTab%rowtype index by pls_integer;
    cursor list_curr is
        select * from ListOfGoods;
    procedure check_del_goods(g_id in ListOfGoods.CodeOfGood%type,
    ret_num out number);
    procedure check_upd_goods (g_id1 in ListOfGoods.CodeOfGood%type,
    g_model in ListOfGoods.Model%type,
    ret_num out number);
    no_goods exception;
    upd_exists exception;
END DB_CMP_TRIG;

create or replace PACKAGE BODY DB_CMP_TRIG AS
procedure check_del_goods(g_id in ListOfGoods.CodeOfGood%type,
    ret_num out number)
IS
t_list1 ListOfGoods%rowtype;
count_id number :=0;
count_changed number := 0;
begin
    DBMS_OUTPUT.PUT_LINE('g_id '||g_id);
    open list_curr;
    loop
        exit when list_curr%notfound;
        if (t_list1.CodeOfGood = g_id) then
            count_id := count_id + 1;
        end if;
        if (t_list1.CodeOfGood = g_id and t_list1.DeleteState = 0) then
            count_changed := count_changed + 1;
        end if;
        fetch list_curr into t_list1;
    end loop;
    close list_curr;
    DBMS_OUTPUT.PUT_LINE('count_id '||count_id);
    if count_id = 0 then raise no_goods;
    elsif count_id is null then raise no_goods;
    end if;
    ret_num := count_changed;
exception
when no_goods THEN
    if count_id is null then
        raise_application_error(-20001, 'Argument is null');
    elsif count_id = 0 then
        raise_application_error(-20002, 'NO GOODS WITH SUCH CODE');
    end if;
when others then raise_application_error(-20010, 'Error found');
end check_del_goods;

procedure check_upd_goods(g_id1 in ListOfGoods.CodeOfGood%type,
    g_model in ListOfGoods.Model%type,
    ret_num out number)
IS
id ListOfGoods.CodeOfGood%type;
begin
    select count(*) into id from ListOfGoods
        where CodeOfGood = g_id1;
    if id <= 0 then raise no_goods;
    elsif id is null then raise no_goods;
    end if;
    select count(*) into ret_num from ListOfGoods
        where CodeOfGood = g_id1 and UpdateState = 1
    and Model = g_model;
    if (ret_num > 0) then raise upd_exists;
    end if;
exception
when no_goods THEN
    if id is null then
        raise_application_error(-20001, 'Argument is null');
    elsif id = 0 then
        raise_application_error(-20002, 'NO GOODS WITH SUCH CODE');
    end if;
when upd_exists then
    raise_application_error(-20003, 'Current update exists');
when others then raise_application_error(-20010, 'Error found');
end check_upd_goods;

END DB_CMP_TRIG;