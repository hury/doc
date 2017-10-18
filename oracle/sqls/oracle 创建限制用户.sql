/*
2017-07-14 14:20:45 @hury
创建限制用户
假设当前数据库用户为 user_a, 需要新增用户 user_b, 用于读写部分 user_a 的用户表；
*/

-- 1、使用 user_a 用户登录

--创建用户
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

-- 2、使用 user_b登录
CREATE OR REPLACE SYNONYM my_table_name FOR  user_a.my_table_name;

-- 测试数据
insert into my_table_name(idcard,name, sex) values('1','user_b1',1);
update my_table_name set name = 'user_b2' where idcard = 1;
commit;
