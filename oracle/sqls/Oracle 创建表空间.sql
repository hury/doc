--������ռ�
create tablespace ��ռ����� datafile 'd:\database\���ݿ�����\���ݿ�����1.dat' size 10m autoextend on next 100m maxsize 32767m;
-- ���������ļ�
ALTER TABLESPACE ��ռ����� ADD DATAFILE 'd:\database\���ݿ�����\���ݿ�����2.dat' SIZE 10m autoextend on next 100m maxsize 32767m;


-- �޶�redo��־
alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;

alter database add logfile group 4 ('d:\DATABASE\���ݿ�����\redo04.log') size 1g; 
alter database add logfile group 5 ('d:\DATABASE\���ݿ�����\redo05.log') size 1g; 
alter database add logfile group 6 ('d:\DATABASE\���ݿ�����\redo06.log') size 1g; 


-- ȡ�������������
alter profile default  limit password_life_time unlimited;  
commit;  

--�����û�
CREATE USER �û��� IDENTIFIED BY ���� 
DEFAULT TABLESPACE ��ռ�����
TEMPORARY TABLESPACE TEMP;

--�����ɫ
GRANT "DBA" TO �û��� WITH ADMIN OPTION;
GRANT "CONNECT" TO �û��� WITH ADMIN OPTION;
ALTER USER �û��� DEFAULT ROLE "DBA","CONNECT";

grant create any trigger to �û���;