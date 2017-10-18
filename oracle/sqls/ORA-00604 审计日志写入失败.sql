2017-10-09 09:25:31 @hury

# 需求描述：
数据采集时，提示如下错误，无法登录数据库：
ORA-00604: error occurred at recursive SQL level 1
ORA-01654: unable to extend index SYS.I_AUD1 by 128 in tablespace SYSTEM
ORA-02002: error while writing to audit trail
ORA-00604: error occurred at recursive SQL level 1
ORA-01654: unable to extend index SYS.I_AUD1 by 128 in tablespace SYSTEM

# 需求分析：
使用本地方式登录oracle
set oracle_sid=orcl
sqlplus / as sysdba

查看审计开关：DB
show parameter audit_trail 

audit_trail=DB，代表的是，oracle将把每次审计跟踪记录在数据库的一张叫做AUD$的表中。
select owner,table_name,tablespace_name from dba_tables a where a.table_name ='AUD$'

select a.tablespace_name,a.bytes,a.autoextensible from dba_data_files a 
where a.tablespace_name='SYSTEM'

# 解决办法：
定期清空aud$表
SQL>truncate table sys.aud$;

1.设置审计参数关闭
alter system set audit_trail=none scope=spfile;

2.重启数据库
SQL>shutdown immediate;
SQL>startup;
