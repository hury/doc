# ORACLE EXPDP����ʹ����ϸ

# �鿴����
expdp -help
impdp -help

# ���ݱù��ߵ����Ĳ��裺

# 1������DIRECTORY
create directory dir_dp as 'D:/oracle/dir_dp';
# 2����Ȩ
Grant read,write on directory dir_dp to zftang;
--�鿴Ŀ¼��Ȩ��
SELECT t.grantee,privilege, directory_name, DIRECTORY_PATH
FROM user_tab_privs t, all_directories d
 WHERE t.table_name(+) = d.directory_name ORDER BY 3, 1;
# 3��ִ�е���
expdp sa/bsoft@dbcenter schemas=bsoft directory=dbcenter_dir dumpfile=dbcenter.dmp logfile=dbcenter.exp.log;

���ӵ�: Oracle Database 10g Enterprise Edition Release 10.2.0.1
With the Partitioning, OLAP and Data Mining options
���� "ZFTANG"."SYS_EXPORT_SCHEMA_01":  zftang/********@fgisdb sch
ory=dir_dp dumpfile=expdp_test1.dmp logfile=expdp_test1.log;  */
��ע��
   1��directory=dir_dp�������ǰ�棬������������󣬻���ʾ 
		ORA-39002: ������Ч
		ORA-39070: �޷�����־�ļ���
		ORA-39087: Ŀ¼�� DATA_PUMP_DIR; ��Ч
     
   2���ڵ��������У�DATA DUMP ������ʹ����һ����ΪSYS_EXPORT_SCHEMA_01�Ķ��󣬴˶������DATA DUMP�������������õ�JOB���֣�
   �����ִ���������ʱ���û��ָ��������JOB������ô�ͻ����һ��Ĭ�ϵ�JOB���֣�����ڵ���������ָ��JOB���־�Ϊ��ָ�����ֳ���
     ���¸ĳɣ�
     expdp user/bsoft@192.0.0.1/dbname schemas=zftang directory=dir_dp dumpfile=expdp_test1.dmp logfile=expdp_test1.log,job_name=my_job1;
   3�����������治Ҫ�зֺţ��������ϵĵ�������е�job����Ϊ��my_job1;����������my_job1����˵���expdp user/bsoft@192.0.0.1/dbname attach=zftang.my_job1ִ�и�����ʱһֱ��ʾ�Ҳ���job��

 

------------------------------------------------------------
# ���ݱõ����ĸ���ģʽ��

# 1�� ����ģʽ������
expdp user/bsoft@192.0.0.1/dbname  tables=zftang.b$i_exch_info,zftang.b$i_manhole_info dumpfile=expdp_test2.dmp logfile=expdp_test2.log directory=dir_dp job_name=my_job

# 2������ѯ����������
expdp user/bsoft@192.0.0.1/dbname  tables=zftang.b$i_exch_info dumpfile=expdp_test3.dmp logfile=expdp_test3.log directory=dir_dp job_name=my_job query='"where rownum<11"'

# 3������ռ䵼����
Expdp user/bsoft@192.0.0.1/dbname dumpfile=expdp_tablespace.dmp tablespaces=GCOMM.DBF logfile=expdp_tablespace.log directory=dir_dp job_name=my_job

# 4����������
Expdp user/bsoft@192.0.0.1/dbname DIRECTORY=dir_dp DUMPFILE=schema.dmp SCHEMAS=zftang,gwm

# 5�������������ݿ⣺
expdp user/bsoft@192.0.0.1/dbname dumpfile=full.dmp full=y logfile=full.log directory=dir_dp job_name=my_job

------------------------------------------------------------
# impdp����ģʽ��

# 1��������
p_street_area.dmp�ļ��еı����ļ�����gwm�û���schemas=gwm�����ģ�
impdp user/bsoft@192.0.0.1/dbname  dumpfile=p_street_area.dmp logfile=imp_p_street_area.log directory=dir_dp tables=p_street_area job_name=my_job

# 2�����û����루���Խ��û���Ϣֱ�ӵ��룬������û���Ϣ�����ڵ������Ҳ����ֱ�ӵ��룩
impdp user/bsoft@192.0.0.1/dbname schemas=gwm dumpfile=expdp_test.dmp logfile=expdp_test.log directory=dir_dp job_name=my_job

# 3����ͨ��expdp�Ĳ�������dmp�ļ���ֱ�ӵ���ķ�����
--��Դ���ݿ�����Ŀ�����ݿ⵼���p_street_area
impdp user/bsoft@192.0.0.1/dbname directory=dir_dp NETWORK_LINK=igisdb tables=p_street_area logfile=p_street_area.log  job_name=my_job
igisdb��Ŀ�����ݿ���Դ���ݵ���������dir_dp��Ŀ�����ݿ��ϵ�Ŀ¼

------------------------------------------------------------
# 4��������ռ�
#   ����remap_tablespace����
--����gwm�û��µ���������
expdp user/bsoft@192.0.0.1/dbname directory=data_pump_dir dumpfile=gwm.dmp SCHEMAS=gwm
# ע���������sys�û��������û����ݣ������û���������Ȩ���֣��������û������򲻺���Щ����
--�����ǽ�gwm�û��µ�����ȫ�����뵽��ռ�gcomm��ԭ��Ϊgmapdata��ռ��£���
impdp user/bsoft@192.0.0.1/dbname directory=data_pump_dir dumpfile=gwm.dmp remap_tablespace=gmapdata:gcomm

------------------------------------------------------------
# 5��ʹ�ò����ļ�parfile��������

������Ҫ������ my_table������Ҫ�޶�ҵ��ʱ�䷶Χ�����½�par�ļ������£�
# my_table.par
directory=dbname_dp 
dumpfile=my_table.all.dmp 
logfile=my_table.all.imp.log 
tables=my_table 
query=" where check_time >=to_date('2016-07-21','yyyy-mm-dd')" 
job_name=dbname_exp_job
compression=all # ������ʱʹ��
Table_exists_action=append # ������ʱʹ��

# ��������ִ��parfile
expdp user/password@10.2.3.4/dbname parfile=my_table.par
# ��������
impdp user/password@10.2.3.4/dbname parfile=my_table.par
------------------------------------------------------------
# ʾ��1
expdp sa/bsoft@dbcenter tables=CDH* dumpfile=CDH.dmp logfile=CDH.exp.log directory=DBCENTER_BAK job_name=dbcenter_job
expdp user/bsoft@192.0.0.1/dbname directory=data_pump_dir dumpfile=gwm.dmp SCHEMAS=gwm

impdp user/bsoft@192.0.0.1/dbname directory=PH_BAK dumpfile=CDH.dmp remap_tablespace=DBCENTER:PH_D
impdp user/bsoft@192.0.0.1/dbname directory=PH_BAK dumpfile=CDH.dmp remap_tablespace=performe1:tcm

------------------------------------------------------------
# impdp table_exists_action����˵��
1)  skip��Ĭ�ϲ���
2)  replace����drop��Ȼ�󴴽�������������
3)  append����ԭ�����ݵĻ�������������
4)  truncate����truncate��Ȼ���ٲ�������

------------------------------------------------------------
# expdp ֹͣ����
expdp user/pwd@dbname ***
ctl+c ���뽻�������У�
Export>stop_job=immediate
Are you sure you wish to stop this job ([yes]/no): yes   

# �鿴����������ͼ
select * from dba_datapump_jobs;

------------------------------------------------------------
# ���impdp/expdp�Ľ��ȷ���
# ������ʹ����䣬��������ִ�е�����
select * from dba_datapump_jobs;
# ����attachΪjob_name���ɲ鿴���ȡ�  
expdp system/oracle attach=SYS_EXPORT_SCHEMA_01