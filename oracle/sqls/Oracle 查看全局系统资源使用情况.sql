Oracle �鿴ȫ��ϵͳ��Դʹ�����
ԭ�ģ�
http://docs.oracle.com/cd/B19306_01/server.102/b14237/dynviews_2050.htm#REFRN30206
����ͼ������ʾϵͳ��Դ��ȫ��ʹ�������ͨ�������ͼ���Լ����Դʹ������Ա����ڱ�Ҫʱ���е�����
���
select * from V$RESOURCE_LIMIT

��������
��Դ����	��ǰֵ		        ��ʷ���ֵ      ��ʼ������              ����޶�ֵ
RESOURCE_NAME	CURRENT_UTILIZATION	MAX_UTILIZATION	INITIAL_ALLOCATION	LIMIT_VALUE
processes	113	242	      2000	      2000
sessions	118	216	      3040	      3040
enqueue_locks	303	503	     35260	     35260
enqueue_resources	220	245	     13596	 UNLIMITED
ges_procs	0	0	         0	         0
ges_ress	0	0	         0	 UNLIMITED
ges_locks	0	0	         0	 UNLIMITED
ges_cache_ress	0	0	         0	 UNLIMITED
ges_reg_msgs	0	0	         0	 UNLIMITED
ges_big_msgs	0	0	         0	 UNLIMITED
ges_rsv_msgs	0	0	         0	         0
gcs_resources	0	0	         0	         0
gcs_shadows	0	0	         0	         0
dml_locks	2	2	     13376	 UNLIMITED
temporary_table_locks	0	0	 UNLIMITED	 UNLIMITED
transactions	4	4	      3344	 UNLIMITED
branches	0	0	      3344	 UNLIMITED
cmtcallbk	2	4	      3344	 UNLIMITED
max_rollback_segments	11	11	      3344	     65535
sort_segment_locks	0	1	 UNLIMITED	 UNLIMITED
k2q_locks	0	0	      6080	 UNLIMITED
max_shared_servers	1	1	 UNLIMITED	 UNLIMITED
parallel_max_servers	64	155	       320	      3600
