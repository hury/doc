--创建表空间
create tablespace 表空间名称 datafile 'd:\database\数据库名称\数据库名称1.dat' size 10m autoextend on next 100m maxsize 32767m;
-- 新增数据文件
ALTER TABLESPACE 表空间名称 ADD DATAFILE 'd:\database\数据库名称\数据库名称2.dat' SIZE 10m autoextend on next 100m maxsize 32767m;


-- 修订redo日志
alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;

alter database add logfile group 4 ('d:\DATABASE\数据库名称\redo04.log') size 1g; 
alter database add logfile group 5 ('d:\DATABASE\数据库名称\redo05.log') size 1g; 
alter database add logfile group 6 ('d:\DATABASE\数据库名称\redo06.log') size 1g; 


-- 取消密码过期限制
alter profile default  limit password_life_time unlimited;  
commit;  

--创建用户
CREATE USER 用户名 IDENTIFIED BY 密码 
DEFAULT TABLESPACE 表空间名称
TEMPORARY TABLESPACE TEMP;

--分配角色
GRANT "DBA" TO 用户名 WITH ADMIN OPTION;
GRANT "CONNECT" TO 用户名 WITH ADMIN OPTION;
ALTER USER 用户名 DEFAULT ROLE "DBA","CONNECT";

grant create any trigger to 用户名;