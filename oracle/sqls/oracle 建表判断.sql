declare
  cnt number;
begin
  ---��ѯҪ�����ı��Ƿ����
  select count(*) into cnt from user_tables where table_name = 'STUDENTS';
  ---���������ɾ���ñ�
  if cnt > 0 then  
    execute immediate 'drop table STUDENTS';  
    dbms_output.put_line('����ڣ�ɾ���ɹ�!');  
  end if;
  ---ɾ��֮���ٴ����ñ�
  execute immediate 'CREATE TABLE STUDENTS
    ( 
    SNO NUMERIC(6, 0) NOT NULL,
    SNAME CHAR (8) NOT NULL ,
    AGE  NUMERIC(3,0) ,
    SEX  CHAR(2) ,
    BPLACE CHAR(20) ,
    PRIMARY KEY(SNO) 
    )';
end;

