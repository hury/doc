# Oracle 表空间迁移
## 用途
将表迁移到新表空间，提高数据检索性能；

## 新建表空间
create tablespace ts_2d_data logging datafile 'h:\database\dbcenter\ts_2d_data_01.dat' size 10m autoextend on next 100m maxsize 32767m extent management local default compress for oltp;
alter tablespace ts_2d_data add datafile 'h:\database\dbcenter\ts_2d_data_01.dat' size 10m autoextend on next 100m maxsize 32767m;
alter tablespace ts_2d_data add datafile 'h:\database\dbcenter\ts_2d_data_01.dat' size 10m autoextend on next 100m maxsize 32767m;

create tablespace ts_2d_index logging datafile 'h:\database\dbcenter\ts_2d_index_01.dat' size 10m autoextend on next 100m maxsize 32767m extent management local default compress for oltp;
alter tablespace ts_2d_index add datafile 'h:\database\dbcenter\ts_2d_index_02.dat' size 10m autoextend on next 100m maxsize 32767m;
alter tablespace ts_2d_index add datafile 'h:\database\dbcenter\ts_2d_index_03.dat' size 10m autoextend on next 100m maxsize 32767m;

## 单表迁移算法：
将表迁移到新表空间：
alter table ... move tablespace ... 
表迁移后需要重建索引：
alter index ... rebuild tablespace ...

## 批量表迁移算法
```
select table_name, sqls, t from (
select  table_name, 'alter table '|| table_name ||' move tablespace ts_2d_data compress;' as sqls, 1 as t
from user_tables 
union all 
select table_name, 'alter index ' || index_name || ' rebuild tablespace ts_2d_index ;'  as sqls , 2 as t
from user_indexes
union all
select  table_name, 'call dbms_stats.gather_table_stats(''PFUSER'','''|| table_name ||''');' as sqls, 3 as t
from user_tables 
) a
where table_name like 'TEST%'
order by 3,1;
```
##  表状态验证
```
select table_name, status, t from (
select  table_name,status, 1 as t from user_tables 
union all 
select index_name,status, 2 as t from user_indexes
) a
where status <> 'VALID'
and table_name like 'TEST%'
order by 3,1;
```