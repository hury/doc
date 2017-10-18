##oracle 安全基线检查

###1.限制超级管理员远程登录
```
检查方法：
使用sqlplus检查参数设置。
SQL> show parameter REMOTE_LOGIN_PASSWORDFILE，参数REMOTE_LOGIN_PASSWORDFILE设置为NONE;

修订算法：
SQL> alter system set remote_login_passwordfile=none scope=spfile;
SQL> shutdown immediate
SQL> startup

恢复为默认值：
SQL> alter system set remote_login_passwordfile=EXCLUSIVE scope=spfile;
SQL> shutdown immediate
SQL> startup
```

###2.用户属性控制
```
检查方法：
查询视图dba_profiles和dba_users来检查profile是否创建。
SQL> Select profile from dba_profiles;
SQL> Select profile from dba_users;
存在default以外的profile即可

修订算法：
SQL> create profile maintenance limit  PASSWORD_VERIFY_FUNCTION F_PASSWORD_VERIFY
PASSWORD_REUSE_MAX 5
PASSWORD_GRACE_TIME 60
FAILED_LOGIN_ATTEMPTS 6
PASSWORD_LIFE_TIME 90;
```

###3.数据字典访问权限
```
检查方法：
使用sqlplus检查参数，
SQL> show parameter O7_DICTIONARY_ACCESSIBILITY
参数O7_DICTIONARY_ACCESSIBILITY设置为FALSE

修订算法：
SQL> alter system set O7_DICTIONARY_ACCESSIBILITY=FALSE scope=spfile;
SQL> shutdown immediate
SQL> startup
```

###4.账户口令的生存期
```
检查方法：
执行
select dba_profiles.profile,resource_name, limit 
from dba_profiles, dba_users 
where dba_profiles.profile = dba_users.profile 
	and dba_users.account_status='OPEN' 
	and resource_name='PASSWORD_GRACE_TIME';
查询结果中PASSWORD_GRACE_TIME小于等于90。

修订算法：
SQL> alter profile default limit PASSWORD_GRACE_TIME 60;
```

###5.重复口令使用
```
检查方法：
执行
select dba_profiles.profile,resource_name, limit 
from dba_profiles, dba_users 
where dba_profiles.profile = dba_users.profile 
	and dba_users.account_status='OPEN' 
	and resource_name='PASSWORD_REUSE_MAX';
查询结果中PASSWORD_REUSE_MAX大于等于5。

修订算法：
SQL> alter profile default limit PASSWORD_REUSE_MAX 5;
```

###6.认证控制
```
检查方法：
执行
select dba_profiles.profile,resource_name, limit 
from dba_profiles, dba_users 
where dba_profiles.profile = dba_users.profile 
	and dba_users.account_status='OPEN' 
	and resource_name='FAILED_LOGIN_ATTEMPTS';
查询结果中FAILED_LOGIN_ATTEMPTS等于6。

修订算法：
SQL>alter profile default limit FAILED_LOGIN_ATTEMPTS 6;
```

###7.更改默认帐户密码
```
检查方法：
sqlplus '/as sysdba'
conn system/system
conn system/manager 
conn sys/sys
conn sys/cHAnge_on_install 
conn scott/scott
conn scott/tiger
conn dbsnmp/dbsnmp 
conn rman/rman
conn xdb/xdb
以上均不能成功登录

修订算法：
不要有空口令和弱口令
```

###8.密码更改策略
```
检查方法：
执行
select profile,limit from dba_profiles 
where resource_name='PASSWORD_LIFE_TIME' 
	and profile in (select profile from dba_users where account_status='OPEN');
查询结果中PASSWORD_LIFE_TIME小于等于90。

修订算法：
SQL> alter profile default limit PASSWORD_LIFE_TIME 90;
```

###9.密码复杂度策略
```
检查方法：
执行
select limit from dba_profiles 
where resource_name = 'PASSWORD_VERIFY_FUNCTION' 
and profile in (select profile from dba_users where account_status = 'OPEN');
select text from dba_source where name='PASSWORD_VERIFY_FUNCTION';
查询结果中不为“NULL”且策略为口令长度至少8位，并包括数字、小写字母、大写字母和特殊符号4类中至少3类

修订算法：
创建复杂度策略
使用 sys 用户登录，执行如下脚本：
D:\app\administrator\product\11.2.0\dbhome_1\RDBMS\ADMIN\utlpwdmg.sql
oracle 10g, 必须使用sys用户登录，oracle 11g，可以使用 system创建；

然后执行如下脚本：
ALTER PROFILE DEFAULT LIMIT
PASSWORD_LIFE_TIME 90
PASSWORD_GRACE_TIME 60
PASSWORD_REUSE_TIME UNLIMITED
PASSWORD_REUSE_MAX 5
FAILED_LOGIN_ATTEMPTS 6
PASSWORD_LOCK_TIME 1
PASSWORD_VERIFY_FUNCTION verify_function;

-- 取消密码有效期，复杂度限制
ALTER PROFILE DEFAULT LIMIT
PASSWORD_LIFE_TIME unlimited
PASSWORD_GRACE_TIME 60
PASSWORD_REUSE_TIME UNLIMITED
PASSWORD_REUSE_MAX 5
FAILED_LOGIN_ATTEMPTS 6
PASSWORD_LOCK_TIME 1
PASSWORD_VERIFY_FUNCTION null;
···

###10.数据库审计策略
```
检查方法：
1.使用参数设置，
SQL> show parameter audit_trail
参数audit_trail不为NONE。
检查dba_audit_trail视图中或$ORACLE_BASE/admin/adump目录下是否有数据。
2.查看审计表，检查是否有用户登录、操作记录
select * from LOGON_AUDIT.LOGON_AUDIT;

修订算法：
SQL> alter system set audit_trail=os scope=spfile;
SQL> shutdown immediate
SQL> startup
```

###11.设置监听器密码
```
检查方法：
检查$ORACLE_HOME/network/admin/listener.ora文件中是否设置参数PASSWORDS_LISTENER。

修订算法：
$ ps -ef|grep tns
$ lsnrctl
LSNRCTL> set current_listener listener 
LSNRCTL> change_password
LSNRCTL> save_config
LSNRCTL> set password  
LSNRCTL> exit
```

###12.限制用户数量
```
检查方法：
检查文件/etc/group，确认除oracle安装用户无其它用户在DBA组中。

修订算法：

```

###13.使用数据库角色（ROLE）来管理对象的权限
```
检查方法：
检查应用用户未授予dba角色：
select * from dba_role_privs where granted_role='DBA';

修订算法：
create role
grant 角色 to username; 
revoke DBA from username; 
```

###14.连接超时设置
```
检查方法：
检查sqlnet.ora文件：
$ cat $ORACLE_HOME/network/admin/sqlnet.ora
查看文件中设置参数SQLNET.EXPIRE_TIME=15。 

修订算法：
$ vi sqlnet.ora
SQLNET.EXPIRE_TIME=10
```

###15.安全补丁
```
检查方法：
查看oracle补丁是否为最新，
$ opatch lsinventory

修订算法：
升级为最新补丁，需要Oracle Metalink 帐号下载安全补丁。
```

###16.可信IP地址访问控制
```
检查方法：
1.检查sqlnet.ora中是否设置
tcp.validnode_checking = yes，
tcp.invited_nodes ：
$ cat $ORACLE_HOME/network/admin/sqlnet.ora

修订算法：
$ vi sqlnet.ora
tcp.validnode_checking = yes 
tcp.invited_nodes = (ip1,ip2…) 
```

###17.资源控制
```
检查方法：
查看空闲超时设置：
select profile,limit from dba_profiles where profile='DEFAULT' and resource_name='IDLE_TIME';

修订算法：
IDLE_TIME返回结果应大于0
```

###18.重要信息资源设置敏感标记
```
检查方法：
1、询问数据库管理员是否对重要数据设置了敏感标记
2、检查是否安装Oracle Label Security 模块：select username from dba_users;
3、查看是否创建策略:select policy_name,status from dba_sa_policies;
4、查看是否创建级别：select * from dba_sa_levels order by level_num;
5、查看标签创建情况：select * from dba_sa_labels;
6、询问重要数据存储表格名称
7、查看策略与模式、表对应关系：select * from dba_sa_table_policies;判断是否针对重要信息资源设置敏感标签。

修订算法：
1、安装了Oracle Label Security模块
2、可以查询到Oracle Label Security对象的用户LBACSYS
3、创建了相应的策略
4、创建了相应的级别
5、创建了标签
6、针对重要数据设置了敏感标记
```

