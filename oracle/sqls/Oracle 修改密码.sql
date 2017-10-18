-- Oracle 修改密码
# 使用sys用户登录，修改如下密码信息；

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
# 忘记oracle密码处理
#1、设置环境变量 oracle_sid
set oracle_sid=xxx

#2、使用os用户登录oracle
sqlplus / as sysdba

# 如果命令提示如下错误：
ORA-01031: 权限不足
# 或
ORA-01031: insufficient privileges

# 解决办法：则打开 sqlnet.ora 文件，查看如下参数：
# 允许os用户登录数据库
SQLNET.AUTHENTICATION_SERVICES = (NTS)
# 仅允许数据库用户登录数据库
SQLNET.AUTHENTICATION_SERVICES = (NONE) 

#3、修改密码
alter user user_name identified by new_pwd;