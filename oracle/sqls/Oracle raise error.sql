oracle�������е�RAISE_APPLICATION_ERROR�÷�
RAISE_APPLICATION_ERROR �ǽ�Ӧ�ó���ר�еĴ���ӷ�������ת�ﵽ�ͻ���Ӧ�ó���(���������ϵ�SQLPLUS��������ǰ̨��������)

RAISE_APPLICATION_ERROR�Ķ���������ʾ��

RAISE_APPLICATION_ERROR(error_number,error_message,[keep_errors]);
����Ĵ����������ݣ������Զ���ġ�˵�����Զ��壬��Ȼ�Ͳ���ϵͳ���Ѿ��������ڵĴ������������һ���Զ�������������ͣ��ŵ��ô˺�����error_number_in ֮����� -20000 �� -20999 ֮�䣬�����Ͳ����� ORACLE ���κδ�����뷢����ͻ��error_message �ĳ��Ȳ��ܳ��� 2k�������ȡ 2k;���keep_errorsΪTRUE��������µĴ��󽫼����Ѳ����Ĵ����б�֮�����keep_errorsΪFALSE��������´��󽫴��浱ǰ�Ĵ����б�

���磺

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
