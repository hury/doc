-- Oracle�ؽ�temp��ռ䣺 
--1.������ת��ʱ��ռ� 
create temporary tablespace TEMP2 TEMPFILE 'd:\database\db_name\temp02.dbf' SIZE 10M REUSE AUTOEXTEND ON NEXT 10m MAXSIZE 32767m;
--2.�ı�ȱʡ��ʱ��ռ� Ϊ�ոմ���������ʱ��ռ�temp2 
alter database default temporary tablespace temp2; 
--3.ɾ��ԭ����ʱ��ռ� 
drop tablespace temp including contents and datafiles;
--4.���´�����ʱ��ռ� 
create temporary tablespace TEMP TEMPFILE 'd:\database\db_name\temp01.dbf' SIZE 10M REUSE AUTOEXTEND ON NEXT 10m MAXSIZE 32767m;
--5.����ȱʡ��ʱ��ռ�Ϊ�½���temp��ռ� 
alter database default temporary tablespace temp; 
--6.ɾ����ת����ʱ��ռ� 
drop tablespace temp2 including contents and datafiles;
--7.����ָ���û���ռ�Ϊ�ؽ�����ʱ��ռ�
alter user user_name temporary tablespace temp; 
