-- Oracle �޸�����
# ʹ��sys�û���¼���޸�����������Ϣ��

ALTER PROFILE DEFAULT 
LIMIT PASSWORD_VERIFY_FUNCTION null
PASSWORD_REUSE_TIME unlimited
PASSWORD_REUSE_MAX unlimited
;

alter user pfuser identified by bsoft;
alter user SYSTEM identified by bsoft;
alter user sys identified by bsoft;
alter user DBSNMP identified by bsoft;
alter user SYSMAN identified by bsoft;

ALTER USER pfuser ACCOUNT UNLOCK;

ALTER PROFILE DEFAULT LIMIT PASSWORD_VERIFY_FUNCTION verify_function;


------------------------------------------------------------
# ����oracle���봦��
#1�����û������� oracle_sid
set oracle_sid=xxx

#2��ʹ��os�û���¼oracle
sqlplus / as sysdba

# ���������ʾ���´���
ORA-01031: Ȩ�޲���
# ��
ORA-01031: insufficient privileges

# ����취����� sqlnet.ora �ļ����鿴���²�����
# ����os�û���¼���ݿ�
SQLNET.AUTHENTICATION_SERVICES = (NTS)
# ���������ݿ��û���¼���ݿ�
SQLNET.AUTHENTICATION_SERVICES = (NONE) 

#3���޸�����
alter user user_name identified by new_pwd;