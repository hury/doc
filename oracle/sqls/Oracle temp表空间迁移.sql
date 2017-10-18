-- Oracle重建temp表空间： 
--1.创建中转临时表空间 
create temporary tablespace TEMP2 TEMPFILE 'd:\database\db_name\temp02.dbf' SIZE 10M REUSE AUTOEXTEND ON NEXT 10m MAXSIZE 32767m;
--2.改变缺省临时表空间 为刚刚创建的新临时表空间temp2 
alter database default temporary tablespace temp2; 
--3.删除原来临时表空间 
drop tablespace temp including contents and datafiles;
--4.重新创建临时表空间 
create temporary tablespace TEMP TEMPFILE 'd:\database\db_name\temp01.dbf' SIZE 10M REUSE AUTOEXTEND ON NEXT 10m MAXSIZE 32767m;
--5.重置缺省临时表空间为新建的temp表空间 
alter database default temporary tablespace temp; 
--6.删除中转用临时表空间 
drop tablespace temp2 including contents and datafiles;
--7.重新指定用户表空间为重建的临时表空间
alter user user_name temporary tablespace temp; 
