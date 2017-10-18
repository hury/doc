正在连接...ORA-12514: TNS: 监听程序当前无法识别连接描述符中请求的服务
测试未成功。

ORA-00844: Parameter not taking MEMORY_TARGET into account
ORA-00851: SGA_MAX_SIZE 19327352832 cannot be set to more than MEMORY_TARGET 18253611008.

set oracle_sid=ehrview

sqlplus / nolog
conn as sysdba

以pfile来重新创建spfile  
-- 从默认位置恢复
create spfile from pfile; 
-- 从指定位置恢复
create spfile from pfile='D:\app\Administrator\admin\ehrview\pfile\init.ora.6202015161042';