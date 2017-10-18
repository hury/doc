/*oracle �鿴��ռ�*/
-- oracle �鿴��ռ��С
select b.tablespace_name����as "��ռ�",
       b.file_id,
       b.file_name����������as "�����ļ���",
       cast(b.maxbytes / 1024 / 1024 / 1024 as number(18, 2)) �� as "�ܴ�СG",
       cast(b.bytes / 1024 / 1024 / 1024 as number(18, 2)) ������as "��ʹ��G",
       cast((b.maxbytes - b.bytes) / 1024 / 1024 / 1024 as number(18, 2)) as "ʣ��G",
       'alter database datafile ' || b.file_id || ' autoextend on next 100m maxsize 32767m; ' as "�޶�1",
       'alter database datafile ' || b.file_id || ' RESIZE 1024M; ' as "�޶�2"
  from dba_data_files b
 order by b.tablespace_name, b.file_name
;

-- oracle �鿴��ռ��С
select b.tablespace_name����as "��ռ�",
       cast(sum(b.maxbytes) / 1024 / 1024 / 1024 as number(18, 2)) �� as "�ܴ�СG",
       cast(sum(b.bytes) / 1024 / 1024 / 1024 as number(18, 2)) ������as "��ʹ��G",
       cast(sum(b.bytes) * 100 / sum(b.maxbytes) as number(18, 2)) as "������",
       cast(sum(b.maxbytes - b.bytes) / 1024 / 1024 / 1024 as number(18, 2)) ��as "ʣ��G"
  from dba_data_files b
 group by b.tablespace_name
 order by b.tablespace_name
;

-- oracle �鿴��ʱ��ռ��С
select b.tablespace_name��as "��ռ�",
       b.file_id,
       b.file_name����������as "�����ļ���",
       cast(b.maxbytes / 1024 / 1024 / 1024 as number(18, 2)) �� as "�ܴ�СG",
       cast(b.bytes / 1024 / 1024 / 1024 as number(18, 2)) ������as "��ʹ��G",
       cast((b.maxbytes - b.bytes) / 1024 / 1024 / 1024 as number(18, 2)) ��as "ʣ��G"
  from dba_temp_files b
 order by b.tablespace_name, b.file_name
;
/*
--������ռ�
create tablespace ts_index datafile 'd:\database\���ݿ�����\���ݿ�����1.dat' size 10m autoextend on next 100m maxsize 32767m;

-- ��������ļ�
alter tablespace db_name add datafile 'd:\DATABASE\db_name\db_name1.DBF' size 10m autoextend on next 10m maxsize 32767m;

--�޸������ļ���С
-- ��ʽ1��
alter database datafile 'd:\DATABASE\db_name\db_name1.DBF' resize 10240m; 
--��ʽ2��
alter database datafile 'd:\DATABASE\db_name\db_name1.DBF' autoextend on next 10m maxsize 32767m;
alter database datafile 5 autoextend on next 10m maxsize 32767m;

-- ��ʱ��ռ�
-- ���
alter tablespace temp add tempfile  'F:\DATABASE\DBCENTER\TEMP01.DBF' size 10m autoextend on next 10m maxsize 15360m;
-- ɾ��
alter database tempfile 1 drop ;
-- �޸�
alter database tempfile 4 resize 1024m; 
alter database tempfile 2 autoextend on next 10m maxsize 10240m; 
*/

------------------------------------------------------------------
/*
Oracle ����������־(redo)��С
����������
Oracle Ĭ��3��50M��redo��־�����ڴ���TPS��ϵͳ�������Ƶ������־�л���Ӱ��ϵͳ���ܣ�
����취��
1������3��redo��־��������־��С����ΪΪ512M��
2���޸�ԭ��redo��־ʱ��������޷�ɾ�������⣬��Ҫ�ȴ���־�л����ٳ��ԡ�
*/
-- �鿴redo��־
select * from v$logfile;
select (a.bytes/ 1024/1024) as "��־��С(M)", a.* from v$log a order by first_time;

/*
-- �޶�redo��־
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
