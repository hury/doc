��������...ORA-12514: TNS: ��������ǰ�޷�ʶ������������������ķ���
����δ�ɹ���

ORA-00844: Parameter not taking MEMORY_TARGET into account
ORA-00851: SGA_MAX_SIZE 19327352832 cannot be set to more than MEMORY_TARGET 18253611008.

set oracle_sid=ehrview

sqlplus / nolog
conn as sysdba

��pfile�����´���spfile  
-- ��Ĭ��λ�ûָ�
create spfile from pfile; 
-- ��ָ��λ�ûָ�
create spfile from pfile='D:\app\Administrator\admin\ehrview\pfile\init.ora.6202015161042';