/*oracle 查看表空间*/
-- oracle 查看表空间大小
select b.tablespace_name　　as "表空间",
       b.file_id,
       b.file_name　　　　　as "物理文件名",
       cast(b.maxbytes / 1024 / 1024 / 1024 as number(18, 2)) 　 as "总大小G",
       cast(b.bytes / 1024 / 1024 / 1024 as number(18, 2)) 　　　as "已使用G",
       cast((b.maxbytes - b.bytes) / 1024 / 1024 / 1024 as number(18, 2)) as "剩余G",
       'alter database datafile ' || b.file_id || ' autoextend on next 100m maxsize 32767m; ' as "修订1",
       'alter database datafile ' || b.file_id || ' RESIZE 1024M; ' as "修订2"
  from dba_data_files b
 order by b.tablespace_name, b.file_name
;

-- oracle 查看表空间大小
select b.tablespace_name　　as "表空间",
       cast(sum(b.maxbytes) / 1024 / 1024 / 1024 as number(18, 2)) 　 as "总大小G",
       cast(sum(b.bytes) / 1024 / 1024 / 1024 as number(18, 2)) 　　　as "已使用G",
       cast(sum(b.bytes) * 100 / sum(b.maxbytes) as number(18, 2)) as "利用率",
       cast(sum(b.maxbytes - b.bytes) / 1024 / 1024 / 1024 as number(18, 2)) 　as "剩余G"
  from dba_data_files b
 group by b.tablespace_name
 order by b.tablespace_name
;

-- oracle 查看临时表空间大小
select b.tablespace_name　as "表空间",
       b.file_id,
       b.file_name　　　　　as "物理文件名",
       cast(b.maxbytes / 1024 / 1024 / 1024 as number(18, 2)) 　 as "总大小G",
       cast(b.bytes / 1024 / 1024 / 1024 as number(18, 2)) 　　　as "已使用G",
       cast((b.maxbytes - b.bytes) / 1024 / 1024 / 1024 as number(18, 2)) 　as "剩余G"
  from dba_temp_files b
 order by b.tablespace_name, b.file_name
;
/*
--创建表空间
create tablespace ts_index datafile 'd:\database\数据库名称\数据库名称1.dat' size 10m autoextend on next 100m maxsize 32767m;

-- 添加数据文件
alter tablespace db_name add datafile 'd:\DATABASE\db_name\db_name1.DBF' size 10m autoextend on next 10m maxsize 32767m;

--修改数据文件大小
-- 方式1：
alter database datafile 'd:\DATABASE\db_name\db_name1.DBF' resize 10240m; 
--方式2：
alter database datafile 'd:\DATABASE\db_name\db_name1.DBF' autoextend on next 10m maxsize 32767m;
alter database datafile 5 autoextend on next 10m maxsize 32767m;

-- 临时表空间
-- 添加
alter tablespace temp add tempfile  'F:\DATABASE\DBCENTER\TEMP01.DBF' size 10m autoextend on next 10m maxsize 15360m;
-- 删除
alter database tempfile 1 drop ;
-- 修改
alter database tempfile 4 resize 1024m; 
alter database tempfile 2 autoextend on next 10m maxsize 10240m; 
*/

------------------------------------------------------------------
/*
Oracle 调整重做日志(redo)大小
需求描述：
Oracle 默认3个50M的redo日志，对于大量TPS的系统，会出现频繁的日志切换，影响系统性能；
解决办法：
1、新增3个redo日志，并将日志大小调整为为512M；
2、修改原有redo日志时，会出现无法删除的问题，需要等待日志切换后再尝试。
*/
-- 查看redo日志
select * from v$logfile;
select (a.bytes/ 1024/1024) as "日志大小(M)", a.* from v$log a order by first_time;

/*
-- 修订redo日志
alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;

alter database add logfile group 1 ('d:\DATABASE\db_name\redo01.log') size 512M reuse;
alter database add logfile group 2 ('d:\DATABASE\db_name\redo02.log') size 512M reuse;
alter database add logfile group 3 ('d:\DATABASE\db_name\redo03.log') size 512M reuse;

alter database add logfile group 4 ('d:\DATABASE\db_name\redo04.log') size 512M; 
alter database add logfile group 5 ('d:\DATABASE\db_name\redo05.log') size 512M; 
alter database add logfile group 6 ('d:\DATABASE\db_name\redo06.log') size 512M; 
*/
