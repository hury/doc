Oracle 表空间数据文件移动的方法

# 实现把用户表空间中的数据文件从某一个路径移动到另一个路径

------------------------------------------------------------
# 一、针对可offline的非系统表空间

# 本例移动oracle的案例表空间(EXAMPLE表空间)

# 1.查看要改变的表空间的数据文件信息
SQL> select tablespace_name,file_name,online_status
 from dba_data_files
 where tablespace_name='EXAMPLE';
 
# 2.将目标表空间设置为脱机状态	
SQL> alter tablespace EXAMPLE offline;

# 3.再次查看目标表空间的状态，确保其已经是脱机状态	
SQL> select tablespace_name,file_name,online_status
 from dba_data_files
 where tablespace_name='EXAMPLE';
 
# 4.将原来的数据文件移动(或复制)到新的路径	
SQL> host move D:\ORADATA\ORCL\EXAMPLE01.DBF D:\ORACLE\ORADATA\

# 5.修改该表空间的数据文件路径	
SQL> alter tablespace EXAMPLE 
 rename datafile 'D:\ORADATA\ORCL\EXAMPLE01.DBF'
 to 'D:\ORACLE\ORADATA\EXAMPLE01.DBF';

# 6.查看该表空间修改后的信息,确保信息无误	
SQL> select tablespace_name,file_name,online_status
 from dba_data_files
 where tablespace_name='EXAMPLE';

# 7.修改该表空间为在线状态	
SQL> alter tablespace EXAMPLE online;

# 8.查看该表空间最后结果	
SQL> select tablespace_name,file_name,online_status
 from dba_data_files
 where tablespace_name='EXAMPLE';
	
# 备注:本方法对SYSAUX、USERS表空间也适用
------------------------------------------------------------

# 二、系统表空间移动

# 该方法需要数据库处于mount状态

# 1.关闭运行中的数据库
SQL> shutdown immediate

# 2.启动数据库到mount状态	
SQL> startup mount

# 3.移动系统表空间(SYSTEM表空间)的数据文件	
SQL> host move D:\ORADATA\ORCL\SYSTEM01.DBF D:\ORACLE\ORADATA\

# 4.修改该表空间的数据文件路径	
SQL> alter database rename file 'I:\DATABASE\DBCENTER\JZCX01.DAT' to 'E:\DATABASE\DBCENTER\JZCX01.DAT';
SQL> alter database rename file 'E:\DATABASE\DBCENTER\TEMP01.DBF' to 'I:\DATABASE\DBCENTER\TEMP01.DBF';
SQL> alter database rename file 'F:\DATABASE\DBCENTER\TEMP03.DBF' to 'I:\DATABASE\DBCENTER\TEMP03.DBF';

# 5.启动数据库，打开实例	
SQL> alter database open;

# 6.查看表空间修改结果	
SQL> select tablespace_name,file_name,online_status 
from dba_data_files 
where tablespace_name='SYSTEM';
 
# 备注:本方法对UNDOTBS1、TEMP表空间也适用。