Oracle ��ռ������ļ��ƶ��ķ���

# ʵ�ְ��û���ռ��е������ļ���ĳһ��·���ƶ�����һ��·��

------------------------------------------------------------
# һ����Կ�offline�ķ�ϵͳ��ռ�

# �����ƶ�oracle�İ�����ռ�(EXAMPLE��ռ�)

# 1.�鿴Ҫ�ı�ı�ռ�������ļ���Ϣ
SQL> select tablespace_name,file_name,online_status
 from dba_data_files
 where tablespace_name='EXAMPLE';
 
# 2.��Ŀ���ռ�����Ϊ�ѻ�״̬	
SQL> alter tablespace EXAMPLE offline;

# 3.�ٴβ鿴Ŀ���ռ��״̬��ȷ�����Ѿ����ѻ�״̬	
SQL> select tablespace_name,file_name,online_status
 from dba_data_files
 where tablespace_name='EXAMPLE';
 
# 4.��ԭ���������ļ��ƶ�(����)���µ�·��	
SQL> host move D:\ORADATA\ORCL\EXAMPLE01.DBF D:\ORACLE\ORADATA\

# 5.�޸ĸñ�ռ�������ļ�·��	
SQL> alter tablespace EXAMPLE 
 rename datafile 'D:\ORADATA\ORCL\EXAMPLE01.DBF'
 to 'D:\ORACLE\ORADATA\EXAMPLE01.DBF';

# 6.�鿴�ñ�ռ��޸ĺ����Ϣ,ȷ����Ϣ����	
SQL> select tablespace_name,file_name,online_status
 from dba_data_files
 where tablespace_name='EXAMPLE';

# 7.�޸ĸñ�ռ�Ϊ����״̬	
SQL> alter tablespace EXAMPLE online;

# 8.�鿴�ñ�ռ������	
SQL> select tablespace_name,file_name,online_status
 from dba_data_files
 where tablespace_name='EXAMPLE';
	
# ��ע:��������SYSAUX��USERS��ռ�Ҳ����
------------------------------------------------------------

# ����ϵͳ��ռ��ƶ�

# �÷�����Ҫ���ݿ⴦��mount״̬

# 1.�ر������е����ݿ�
SQL> shutdown immediate

# 2.�������ݿ⵽mount״̬	
SQL> startup mount

# 3.�ƶ�ϵͳ��ռ�(SYSTEM��ռ�)�������ļ�	
SQL> host move D:\ORADATA\ORCL\SYSTEM01.DBF D:\ORACLE\ORADATA\

# 4.�޸ĸñ�ռ�������ļ�·��	
SQL> alter database rename file 'I:\DATABASE\DBCENTER\JZCX01.DAT' to 'E:\DATABASE\DBCENTER\JZCX01.DAT';
SQL> alter database rename file 'E:\DATABASE\DBCENTER\TEMP01.DBF' to 'I:\DATABASE\DBCENTER\TEMP01.DBF';
SQL> alter database rename file 'F:\DATABASE\DBCENTER\TEMP03.DBF' to 'I:\DATABASE\DBCENTER\TEMP03.DBF';

# 5.�������ݿ⣬��ʵ��	
SQL> alter database open;

# 6.�鿴��ռ��޸Ľ��	
SQL> select tablespace_name,file_name,online_status 
from dba_data_files 
where tablespace_name='SYSTEM';
 
# ��ע:��������UNDOTBS1��TEMP��ռ�Ҳ���á�