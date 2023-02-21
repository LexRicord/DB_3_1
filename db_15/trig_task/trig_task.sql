create or replace trigger cmp_trig
    for delete or update on ListOfGoods
    compound trigger
    checks number;
    v_rowList LISTOFGOODS%rowtype;
    v_rowList2 LISTOFGOODS%rowtype;
    v_row DB_CMP_TRIG.t_listofgoods;
    before each row is
    begin
        if deleting then
        v_rowList.CodeOfGood := :old.CodeOfGood;
        v_rowList.ProducerCode := :old.ProducerCode;
        v_rowList.Model := :old.Model;
        v_rowList.Price  := :old.Price;
        DBMS_OUTPUT.PUT_LINE(v_rowList.Price);
        v_rowList.UPDATEDATE:= :old.UPDATEDATE;
        v_rowList.UPDATESTATE := :old.UPDATESTATE;
     end if;
        if updating then
        v_rowList2.CodeOfGood := :old.CodeOfGood;
        v_rowList2.ProducerCode := :old.ProducerCode;
        v_rowList2.Model := :new.Model;
        v_rowList2.Price  := :new.Price;
        :new.Model := :old.Model;
        :new.UPDATESTATE := 1;
        :new.UPDATEDATE := sysdate;
        :new.DeleteDate := :old.DeleteDate;
        if :old.DELETESTATE is null then
        begin
            :new.DELETESTATE := 0;
            v_rowList2.DELETESTATE := 0;
        end;
        else
            begin
                :new.DeleteState := :old.DeleteState;
                v_rowList2.DELETESTATE := :old.DeleteState;
            end;
        end if;
    end if;
    end before each row;
    after statement is
    begin
        if deleting then
            insert into LISTOFGOODS (CODEOFGOOD, PRODUCERCODE, MODEL, PRICE, DELETEDATE,DELETESTATE,UPDATESTATE,UPDATEDATE)
            values (v_rowList.CodeOfGood, v_rowList.ProducerCode, v_rowList.Model,
            v_rowList.Price, sysdate, 1, v_rowList.UPDATESTATE, v_rowList.UPDATEDATE);
            dbms_output.PUT_LINE('Soft delete произведён успешно. Код товара: '||v_rowList.CodeOfGood);
        end if;
        if updating then
            insert into LISTOFGOODS (CODEOFGOOD, PRODUCERCODE, MODEL, PRICE, UPDATESTATE, DELETESTATE, DELETEDATE)
            values (v_rowList2.CodeOfGood, v_rowList2.ProducerCode, v_rowList2.Model,
            v_rowList2.Price, 0, v_rowList2.DELETESTATE, v_rowList2.DELETEDATE);
            dbms_output.PUT_LINE('Soft update произведён успешно. Код товара: '||v_rowList2.CodeOfGood);
        end if;
    end after statement;
 end cmp_trig;