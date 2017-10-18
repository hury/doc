# ORACLE EXPDP命令使用详细

# 查看帮助
expdp -help
impdp -help

# 数据泵工具导出的步骤：

# 1、创建DIRECTORY
create directory dir_dp as 'D:/oracle/dir_dp';
# 2、授权
Grant read,write on directory dir_dp to zftang;
--查看目录及权限
SELECT t.grantee,privilege, directory_name, DIRECTORY_PATH
FROM user_tab_privs t, all_directories d
 WHERE t.table_name(+) = d.directory_name ORDER BY 3, 1;
# 3、执行导出
expdp sa/bsoft@dbcenter schemas=bsoft directory=dbcenter_dir dumpfile=dbcenter.dmp logfile=dbcenter.exp.log;

连接到: Oracle Database 10g Enterprise Edition Release 10.2.0.1
With the Partitioning, OLAP and Data Mining options
启动 "ZFTANG"."SYS_EXPORT_SCHEMA_01":  zftang/********@fgisdb sch
ory=dir_dp dumpfile=expdp_test1.dmp logfile=expdp_test1.log;  */
备注：
   1、directory=dir_dp必须放在前面，如果将其放置最后，会提示 
		ORA-39002: 操作无效
		ORA-39070: 无法打开日志文件。
		ORA-39087: 目录名 DATA_PUMP_DIR; 无效
     
   2、在导出过程中，DATA DUMP 创建并使用了一个名为SYS_EXPORT_SCHEMA_01的对象，此对象就是DATA DUMP导出过程中所用的JOB名字，
   如果在执行这个命令时如果没有指定导出的JOB名字那么就会产生一个默认的JOB名字，如果在导出过程中指定JOB名字就为以指定名字出现
     如下改成：
     expdp user/bsoft@192.0.0.1/dbname schemas=zftang directory=dir_dp dumpfile=expdp_test1.dmp logfile=expdp_test1.log,job_name=my_job1;
   3、导出语句后面不要有分号，否则如上的导出语句中的job表名为‘my_job1;’，而不是my_job1。因此导致expdp user/bsoft@192.0.0.1/dbname attach=zftang.my_job1执行该命令时一直提示找不到job表

 

------------------------------------------------------------
# 数据泵导出的各种模式：

# 1、 按表模式导出：
expdp user/bsoft@192.0.0.1/dbname  tables=zftang.b$i_exch_info,zftang.b$i_manhole_info dumpfile=expdp_test2.dmp logfile=expdp_test2.log directory=dir_dp job_name=my_job

# 2、按查询条件导出：
expdp user/bsoft@192.0.0.1/dbname  tables=zftang.b$i_exch_info dumpfile=expdp_test3.dmp logfile=expdp_test3.log directory=dir_dp job_name=my_job query='"where rownum<11"'

# 3、按表空间导出：
Expdp user/bsoft@192.0.0.1/dbname dumpfile=expdp_tablespace.dmp tablespaces=GCOMM.DBF logfile=expdp_tablespace.log directory=dir_dp job_name=my_job

# 4、导出方案
Expdp user/bsoft@192.0.0.1/dbname DIRECTORY=dir_dp DUMPFILE=schema.dmp SCHEMAS=zftang,gwm

# 5、导出整个数据库：
expdp user/bsoft@192.0.0.1/dbname dumpfile=full.dmp full=y logfile=full.log directory=dir_dp job_name=my_job

------------------------------------------------------------
# impdp导入模式：

# 1、按表导入
p_street_area.dmp文件中的表，此文件是以gwm用户按schemas=gwm导出的：
impdp user/bsoft@192.0.0.1/dbname  dumpfile=p_street_area.dmp logfile=imp_p_street_area.log directory=dir_dp tables=p_street_area job_name=my_job

# 2、按用户导入（可以将用户信息直接导入，即如果用户信息不存在的情况下也可以直接导入）
impdp user/bsoft@192.0.0.1/dbname schemas=gwm dumpfile=expdp_test.dmp logfile=expdp_test.log directory=dir_dp job_name=my_job

# 3、不通过expdp的步骤生成dmp文件而直接导入的方法：
--从源数据库中向目标数据库导入表p_street_area
impdp user/bsoft@192.0.0.1/dbname directory=dir_dp NETWORK_LINK=igisdb tables=p_street_area logfile=p_street_area.log  job_name=my_job
igisdb是目的数据库与源数据的链接名，dir_dp是目的数据库上的目录

------------------------------------------------------------
# 4、更换表空间
#   采用remap_tablespace参数
--导出gwm用户下的所有数据
expdp user/bsoft@192.0.0.1/dbname directory=data_pump_dir dumpfile=gwm.dmp SCHEMAS=gwm
# 注：如果是用sys用户导出的用户数据，包括用户创建、授权部分，用自身用户导出则不含这些内容
--以下是将gwm用户下的数据全部导入到表空间gcomm（原来为gmapdata表空间下）下
impdp user/bsoft@192.0.0.1/dbname directory=data_pump_dir dumpfile=gwm.dmp remap_tablespace=gmapdata:gcomm

------------------------------------------------------------
# 5、使用参数文件parfile导出数据

例如需要导出表 my_table，且需要限定业务时间范围，则新建par文件，如下：
# my_table.par
directory=dbname_dp 
dumpfile=my_table.all.dmp 
logfile=my_table.all.imp.log 
tables=my_table 
query=" where check_time >=to_date('2016-07-21','yyyy-mm-dd')" 
job_name=dbname_exp_job
compression=all # 仅导出时使用
Table_exists_action=append # 仅导入时使用

# 导出命令执行parfile
expdp user/password@10.2.3.4/dbname parfile=my_table.par
# 导入命令
impdp user/password@10.2.3.4/dbname parfile=my_table.par
------------------------------------------------------------
# 示例1
expdp sa/bsoft@dbcenter tables=CDH* dumpfile=CDH.dmp logfile=CDH.exp.log directory=DBCENTER_BAK job_name=dbcenter_job
expdp user/bsoft@192.0.0.1/dbname directory=data_pump_dir dumpfile=gwm.dmp SCHEMAS=gwm

impdp user/bsoft@192.0.0.1/dbname directory=PH_BAK dumpfile=CDH.dmp remap_tablespace=DBCENTER:PH_D
impdp user/bsoft@192.0.0.1/dbname directory=PH_BAK dumpfile=CDH.dmp remap_tablespace=performe1:tcm

------------------------------------------------------------
# impdp table_exists_action参数说明
1)  skip：默认操作
2)  replace：先drop表，然后创建表，最后插入数据
3)  append：在原来数据的基础上增加数据
4)  truncate：先truncate，然后再插入数据

------------------------------------------------------------
# expdp 停止导出
expdp user/pwd@dbname ***
ctl+c 进入交互命令行：
Export>stop_job=immediate
Are you sure you wish to stop this job ([yes]/no): yes   

# 查看导出任务视图
select * from dba_datapump_jobs;

------------------------------------------------------------
# 监控impdp/expdp的进度方法
# 首先是使用语句，查找正在执行的任务
select * from dba_datapump_jobs;
# 设置attach为job_name即可查看进度。  
expdp system/oracle attach=SYS_EXPORT_SCHEMA_01