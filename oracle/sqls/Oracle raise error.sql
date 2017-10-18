oracle触发器中的RAISE_APPLICATION_ERROR用法
RAISE_APPLICATION_ERROR 是将应用程序专有的错误从服务器端转达到客户端应用程序(其他机器上的SQLPLUS或者其他前台开发语言)

RAISE_APPLICATION_ERROR的定义如下所示：

RAISE_APPLICATION_ERROR(error_number,error_message,[keep_errors]);
里面的错误代码和内容，都是自定义的。说明是自定义，当然就不是系统中已经命名存在的错误类别，是属于一种自定义事务错误类型，才调用此函数。error_number_in 之容许从 -20000 到 -20999 之间，这样就不会与 ORACLE 的任何错误代码发生冲突。error_message 的长度不能超过 2k，否则截取 2k;如果keep_errors为TRUE，则这个新的错误将加在已产生的错误列表之后。如果keep_errors为FALSE，则这个新错误将代替当前的错误列表。

比如：

create trigger TR_FORBID_INSERT before insert
on MS_GHMX for each row
declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;

begin

if lower(:NEW.KETTLE_CODE)='xxx' then
        RAISE_APPLICATION_ERROR(-20001, 'kettle_code error:xxx, send msg to dba.');
    end if;
end;
/
