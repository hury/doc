declare
  cnt number;
begin
  ---查询要创建的表是否存在
  select count(*) into cnt from user_tables where table_name = 'STUDENTS';
  ---如果存在则删除该表
  if cnt > 0 then  
    execute immediate 'drop table STUDENTS';  
    dbms_output.put_line('表存在，删除成功!');  
  end if;
  ---删除之后再创建该表
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

