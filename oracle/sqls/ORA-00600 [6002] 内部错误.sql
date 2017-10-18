2016-10-9 17:48:05 @hury
ORA-00600: 内部错误

# 需求描述：
部分社区院长查询到数据中心脚本执行异常，无法传输成功；

# 需求分析：
-- 查看etl错误日志
2016/10/09 16:13:21 - MS_GHMX插入 / 更新.0 - ERROR (...) : Unexpected error : 
2016/10/09 16:13:21 - MS_GHMX插入 / 更新.0 - ERROR (...) : org.pentaho.di.core.exception.KettleStepException: 
2016/10/09 16:13:21 - MS_GHMX插入 / 更新.0 - ERROR (...) : Error in step, asking everyone to stop because of:
2016/10/09 16:13:21 - MS_GHMX插入 / 更新.0 - ERROR (...) : 
2016/10/09 16:13:21 - MS_GHMX插入 / 更新.0 - ERROR (...) : Error inserting/updating row
2016/10/09 16:13:21 - MS_GHMX插入 / 更新.0 - ERROR (...) : ORA-00600: 内部错误代码, 参数: [6002], [0], [0], [3], [5], [], [], [], [], [], [], []
                                                    ...
2016/10/09 16:13:21 - MS_GHMX插入 / 更新.0 - ERROR (...) : 
2016/10/09 16:13:21 - MS_GHMX插入 / 更新.0 - ERROR (...) : org.pentaho.di.trans.steps.insertupdate.InsertUpdate.processRow(InsertUpdate.java:307)
2016/10/09 16:13:21 - MS_GHMX插入 / 更新.0 - ERROR (...) : org.pentaho.di.trans.step.RunThread.run(RunThread.java:40)
2016/10/09 16:13:21 - MS_GHMX插入 / 更新.0 - ERROR (...) : java.lang.Thread.run(Thread.java:662)

-- 查看oracle 日志 log.xml
<msg time='2016-10-09T16:13:17.328+08:00' org_id='oracle' comp_id='rdbms'
 msg_id='400081772' type='INCIDENT_ERROR' group='Generic Internal Error'
 level='1' host_id='WSJ-BSOFT-01' host_addr='172.16.1.120'
 prob_key='ORA 600 [6002]' upstream_comp='' downstream_comp=''
 ecid='' errid='45305' detail_path='d:\app\administrator\diag\rdbms\dbcenter\dbcenter\trace\dbcenter_ora_9060.trc'>
 <attr name=&apos;IMPACT&apos; value=&apos;POSSIBLE INDEX CORRUPTION&apos;/>
 <txt>Errors in file d:\app\administrator\diag\rdbms\dbcenter\dbcenter\trace\dbcenter_ora_9060.trc  (incident=45305):
ORA-00600: 内部错误代码, 参数: [6002], [0], [0], [3], [5], [], [], [], [], [], [], []
 </txt>

方案1：可能是表 MS_GHMX 索引损坏问题，进行如下修复；
BEGIN 
	--执行时长约：41分钟
	DBMS_STATS.GATHER_TABLE_STATS('SA', 'MS_GHMX', estimate_percent=>NULL, cascade=>TRUE); 
END;

效果：应用上述修复后，测试发现，问题仍然出现。

方案2：重启oracle数据库。
效果：重启数据库后，etl传输正常

# 解决办法：
重启数据库