/*
2017-07-14 14:20:45 @hury
���������û�
���赱ǰ���ݿ��û�Ϊ user_a, ��Ҫ�����û� user_b, ���ڶ�д���� user_a ���û���
*/

-- 1��ʹ�� user_a �û���¼

--�����û�
CREATE USER user_b IDENTIFIED BY "user_b@20160708"
DEFAULT TABLESPACE tbs1
TEMPORARY TABLESPACE TEMP;

GRANT "CONNECT" TO user_b ;

grant select on my_table_name to user_b;
grant update on my_table_name to user_b;
grant insert on my_table_name to user_b;
grant  create SYNONYM to user_b;


select * from user_tables;
select * from user_a.my_table_name;

select * from my_table_name;

-- 2��ʹ�� user_b��¼
CREATE OR REPLACE SYNONYM my_table_name FOR  user_a.my_table_name;

-- ��������
insert into my_table_name(idcard,name, sex) values('1','user_b1',1);
update my_table_name set name = 'user_b2' where idcard = 1;
commit;
