Oracle Job 语法和时间间隔的设定
oracle job简介 
主要的使用情景 
定时在后台执行相关操作:如每天晚上0点将一张表的数据保存到另一张表中,2：定时备份数据库等 

初始化相关参数
job_queue_processes
alter system set job_queue_processes=39 scope=spfile;//最大值不能超过1000 ;job_queue_interval = 10 //调度作业刷新频率秒为单位
job_queue_process 表示oracle能够并发的job的数量，可以通过语句　　
show parameter job_queue_process;
来查看oracle中job_queue_process的值。当job_queue_process值为0时表示全部停止oracle的job，可以通过语句
ALTER SYSTEM SET job_queue_processes = 10;
来调整启动oracle的job。
相关视图：
dba_jobs
all_jobs
user_jobs
dba_jobs_running 包含正在运行job相关信息

－－－－－－－－－－－－－－－－－－－－－－－－－
提交job语法：
begin
sys.dbms_job.submit(job => :job,
 what => 'P_CLEAR_PACKBAL;',
 next_date => to_date('04-08-2008 05:44:09', 'dd-mm-yyyy hh24:mi:ss'),
 interval => 'sysdate+ 1/360');
commit;
end;
/

－－－－－－－－－－－－－－－－－－－－－－－－－
创建JOB
variable jobno number;
begin
dbms_job.submit(:jobno, 'P_CRED_PLAN;',SYSDATE,'SYSDATE+1/2880',TRUE);
commit;
运行JOB
SQL> begin
 dbms_job.run(:job1);
 end;
 /
删除JOB
SQL> begin
 dbms_job.remove(:job1);
 end;
 /
DBA_JOBS
＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
字段（列） 类型 描述
JOB NUMBER 任务的唯一标示号
LOG_USER VARCHAR2(30) 提交任务的用户
PRIV_USER VARCHAR2(30) 赋予任务权限的用户
SCHEMA_USER VARCHAR2(30) 对任务作语法分析的用户模式
LAST_DATE DATE 最后一次成功运行任务的时间
LAST_SEC VARCHAR2(8) 如HH24:MM:SS格式的last_date日期的小时，分钟和秒
THIS_DATE DATE 正在运行任务的开始时间，如果没有运行任务则为null
THIS_SEC VARCHAR2(8) 如HH24:MM:SS格式的this_date日期的小时，分钟和秒
NEXT_DATE DATE 下一次定时运行任务的时间
NEXT_SEC VARCHAR2(8) 如HH24:MM:SS格式的next_date日期的小时，分钟和秒
TOTAL_TIME NUMBER 该任务运行所需要的总时间，单位为秒
BROKEN VARCHAR2(1) 标志参数，Y标示任务中断，以后不会运行
INTERVAL VARCHAR2(200) 用于计算下一运行时间的表达式
FAILURES NUMBER 任务运行连续没有成功的次数
WHAT VARCHAR2(2000) 执行任务的PL/SQL块
CURRENT_SESSION_LABEL RAW MLSLABEL 该任务的信任Oracle会话符
CLEARANCE_HI RAW MLSLABEL 该任务可信任的Oracle最大间隙
CLEARANCE_LO RAW MLSLABEL 该任务可信任的Oracle最小间隙
NLS_ENV VARCHAR2(2000) 任务运行的NLS会话设置
MISC_ENV RAW(32) 任务运行的其他一些会话参数

－－－－－－－－－－－－－－－－－－－－－－－－－－
描述 INTERVAL参数值
每天午夜12点 'TRUNC(SYSDATE + 1)'
每天早上8点30分 'TRUNC(SYSDATE + 1) + （8*60+30）/(24*60)'
每星期二中午12点 'NEXT_DAY(TRUNC(SYSDATE ), ''TUESDAY'' ) + 12/24'
每个月第一天的午夜12点 'TRUNC(LAST_DAY(SYSDATE ) + 1)'
每个季度最后一天的晚上11点 'TRUNC(ADD_MONTHS(SYSDATE + 2/24, 3 ), 'Q' ) -1/24'
每星期六和日早上6点10分 'TRUNC(LEAST(NEXT_DAY(SYSDATE, ''SATURDAY"), NEXT_DAY(SYSDATE, "SUNDAY"))) + （6×60+10）/（24×60）'

－－－－－－－－－－－－－－－－－－－－－－－－－－
1:每分钟执行
Interval => TRUNC(sysdate,'mi') + 1/ (24*60)
2:每天定时执行
例如：每天的凌晨1点执行
Interval => TRUNC(sysdate) + 1 +1/ (24)
3:每周定时执行
例如：每周一凌晨1点执行
Interval => TRUNC(next_day(sysdate,'星期一'))+1/24
4:每月定时执行
例如：每月1日凌晨1点执行
Interval =>TRUNC(LAST_DAY(SYSDATE))+1+1/24
5:每季度定时执行
例如每季度的第一天凌晨1点执行
Interval => TRUNC(ADD_MONTHS(SYSDATE,3),'Q') + 1/24
6:每半年定时执行
例如：每年7月1日和1月1日凌晨1点
Interval => ADD_MONTHS(trunc(sysdate,'yyyy'),6)+1/24
7:每年定时执行
例如：每年1月1日凌晨1点执行
Interval =>ADD_MONTHS(trunc(sysdate,'yyyy'),12)+1/24


1、创建一个简单的job 
步骤如下： 
1、创建一张表g_test 
create table G_TEST 
( 
ID     NUMBER(12), 
C_DATE DATE 
) 
2、创建一个sequence 
create sequence G_SEQ 
minvalue 1 
maxvalue 999999999999999999999999999 
start with 141 
increment by 1 
cache 20; 

3、创建一个存储过程 
create or replace procedure prc_g_test is 
begin 
insert into g_test values(g_seq.nextval,sysdate); 
end prc_g_test; 

4、创建job, 
使用Submit()过程，工作被正常地计划好。 
这个过程有五个参数：job、what、next_date、interval与no_parse。 

PROCEDURE Submit ( job       OUT binary_ineger, 
What      IN  varchar2, 
next_date IN  date, 
interval  IN  varchar2, 
no_parse  IN  booean:=FALSE) 

job参数是由Submit()过程返回的binary_ineger。这个值用来唯一标识一个工作。 
what参数是将被执行的PL/SQL代码块。 
next_date参数指识何时将运行这个工作。 
interval参数何时这个工作将被重执行。 
no_parse参数指示此工作在提交时或执行时是否应进行语法分析——TRUE 
指示此PL/SQL代码在它第一次执行时应进行语法分析， 
而FALSE指示本PL/SQL代码应立即进行语法分析。 

在command window窗口中执行下面脚本 
variable job1 number; 
begin 
sys.dbms_job.submit(job => :job, 
what => 'prc_g_test;', 
next_date => to_date('22-10-2008 10:06:41', 'dd-mm-yyyy hh24:mi:ss'), 
interval => 'trunc(sysdate)+1/1440');--每天1440分钟，即一分钟运行test过程一次 
commit; 
end; 
/ 

----------------------------------------------------------------------------------
在plSQL中我的做法是：

declare   
job number;      
begin
sys.dbms_job.submit(job,'prc_g_test;',sysdate,'sysdate+1/1440');
end;
----------------------------------------------------------------------------------

5、查看创建的job 
查看相关job信息 
1、相关视图 
dba_jobs 
all_jobs 
user_jobs 
dba_jobs_running 包含正在运行job相关信息。 
如： 
select * from dba_jobs 

6、运行JOB 
说明：Run()过程用来立即执行一个指定的工作。这个过程只接收一个参数： 
SQL> begin 
2  dbms_job.run(:job); 
3  end; 
4  / 

----------------------------------------------------------------------------------
在plSQL中我的做法是：
begin
dbms_job.run(3017);
end; 
----------------------------------------------------------------------------------

7、删除JOB 
begin 
    dbms_job.remove(:job);--:job可以用dba_jobs.job的值代替如：1198 
end; 
 

8、调整JOB
BEGIN
-- 调整job调度时间
   --DBMS_JOB.CHANGE(101, null, to_date('2012-04-01','yyyy-mm-dd'), 'trunc(sysdate+7)');
   COMMIT;
END;

/*
时间格式：
Trunc(sysdate+1)  --每天0点执行执行一次
Trunc(sysdate+1)+1/24  --每天1点执行一次

*/
9、停止JOB
BEGIN
-- 停止调度job
  --dbms_job.broken(121,true);
   COMMIT;
END;

ORACLE如何停止一个JOB
1、相关表、视图
　dba_jobs
　　all_jobs
　　user_jobs 包含登录用户所有的JOB信息
　　dba_jobs_running 包含正在运行job相关信息
注意
  须使用oracle的sys用户登录到数据库，才能查看dba_jobs_running, v$process, v$session表的信息。同时，登录操作系统时，要用oracle用户。
2、问题描述
为同事解决一个因为网络连接情况不佳时，执行一个超长时间的SQL插入操作。
既然网络状况不好，就选择了使用一次性使用JOB来完成该插入操作。在JOB执行一段时间后，我发现被插入表有些问题（惭愧，当时也没有先检查检查就做了）。准备停止JOB，因为在JOB运行情况下，我的所有修改都会报系统资源忙的错误。
强行KILL SESSION是行不通的，因为过会儿，JOB还会重新启动，如果执行的SQL也被KILL了通过重新启动的JOB还是会被再次新执行的。 
3、解决办法
   比较好的方法应该是; 
1. 首先确定要停止的JOB号
    在10g中可通过Dba_Jobs_Running进行确认。
    查找正在运行的JOB:
    select sid from dba_jobs_running;
 
    查找到正在运行的JOB的spid:
    select a.spid from v$process a ,v$session b where a.addr=b.paddr  and b.sid in (select sid from dba_jobs_running);
 
 2. Broken你确认的JOB    
    注意使用DBMS_JOB包来标识你的JOB为BROKEN。
    SQL> EXEC DBMS_JOB.BROKEN(job#,TRUE);
   注意：当执行完该命令你选择的这个JOB还是在运行着的。
 
3. Kill 对应的Oracle Session
    应为BROKEN后该JOB还在运行，如果要求该JOB立刻停止，就需要找到该job的对应SESSION(SID,SERIAL#)，然后执行以下命令：
    ALTER SYSTEM KILL SESSION 'sid,serial#';
     或者直接KILL对应的操作系统的SESSION，如果使用ALTER SYSTEM KILL SESSION执行很长时间，其实可以使用OS的命令来快速KILL掉SESSION.
     For Windows, at the DOS Prompt: orakill sid spid
     For UNIX at the command line> kill –9 spid
 
4. 检查你的JOB是否还在运行
   检查你要停止的JOB是否还在运行，其实多数情况下，应该都已经停止了。尤其执行的第三步的“杀手”命令。如果真的还是没有停止，只好从第一道第三步重新做一下了。
 
5. 将Job Queue Processes的数目修改为0  
    首先确认当前的Job Queue Processes的数目
    SQL> col value for a10
    SQL> select name,value from v$parameter where name ='job_queue_processes';     
    然后将Job Queue Processes的数目修改为0
    SQL> ALTER SYSTEM SET job_queue_processes = 0;
     保证所有的JOB都会停止。
 
6. 修改你要修改的任何东西，甚至是JOB内的内容。
 
7. 修改完成后，将job的BROKEN状态停止。
SQL>EXEC DBMS_JOB.BROKEN(job#,FALSE):
 
8. 恢复job_queue_processes的原始值
     ALTER SYSTEM SET job_queue_processes = original_value;
    至此整个停止并修改JOB完成.
     
    但是需要另外注意一下的是，在MARK一个BROKEN状态的时候，因为JOB内部执行SQL的原因，所以执行时或许要“煎熬”一段时间。所以在建立JOB时一定要仔细考虑，同时如果可能可以在你设计的PL/SQL代码中，增加一些判断“停止信号”的部分。来避免费力执行上面的步骤。
    毕竟，ORACLE在执行JOB时，还是很“倔强”的 -:)
 
4、附件：ORAKILL用法
很多时候遇到某个session一直处于active，使得CPU一直处于搞使用状态，虽然kill 了，但是却不能够使得使得线程结束。 kill session只是kill这个进程，但是线程一直处于活动状态。需要真正的kill线程才能够解决cpu使用率高的问题。
os ：windows2003
ORAKILL用法是 orakill sid spid 其中sid为实例名，spid为线程号。
怎么样取得这个spid呢？
以下给出查找spid的语句。
select spid, osuser, s.program from  v$process p, v$session s 
where p.addr=s.paddr  and s.sid = XXX;
--说明:XXX为session的sid (不是数据库SID 呵呵)。自己输入就可以。
orakill instance_name spid
这样就能够成功解决cpu使用率高的问题
