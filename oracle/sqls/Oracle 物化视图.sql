/*
2016-7-13 11:01:57 @hury
�ﻯ��ͼ
�ο���http://www.cnblogs.com/Ronger/archive/2012/03/28/2420962.html
*/

/*
 1���ﻯ��ͼ�����ͣ�ON DEMAND��ON COMMIT 
 ���ߵ���������ˢ�·����Ĳ�ͬ��
 ON DEMAND����˼�壬���ڸ��ﻯ��ͼ����Ҫ����ˢ���ˣ��Ž���ˢ��(REFRESH)���������ﻯ��ͼ���Ա�֤�ͻ������ݵ�һ���ԣ�
 ON COMMIT��˵��һ����������COMMIT���������ύ��������ˢ�£����̸����ﻯ��ͼ��ʹ�����ݺͻ���һ�¡�
*/

-- 2��ON DEMAND�ﻯ��ͼ    
-- ԭʼ��
select * from organ_compare;

-- �ﻯ��ͼ ��ϸ
create materialized view mv_organ_compare 
refresh complete ON DEMAND as
select * from organ_compare;

-- ɾ���ﻯ��ͼ
drop materialized view mv_organ_compare ;

-- �ﻯ��ͼ ͳ��
create materialized view mv_organ_compare_cnt as
select parentcode, parentname,count(1) as sl 
from organ_compare group by parentcode, parentname;

--��ȫˢ��
BEGIN
     DBMS_MVIEW.REFRESH('MV_ORGAN_COMPARE','C');
END;

-- 3��ON COMMIT�ﻯ��ͼ
-- ����ON COMMIT�ﻯ��ͼ��
-- ��ע��ʵ�ʴ��������У�������Ҫ������Լ��������ᱨ��ORA-12014�� 
create materialized view mv_name refresh force on commit as select * from table_name    
 
 
---------------------------------------------
select * from systemusers;

--�����ﻯ��ͼ��־
create materialized view log on systemusers;  
create materialized view mv_systemusers as select * from systemusers;

select * from mv_systemusers;

--����ˢ�£�Ҳ��������ˢ��
begin
dbms_mview.refresh('MV_SYSTEMUSERS', 'F');
end;
-------------------------------------------------------------

--�����ﻯ��ͼ��Ҫ��Ȩ�ޣ�
grant create materialized view to user_name; 
 
--��Դ�����ﻯ��ͼ��־��
create materialized view log on test_table  
tablespace test_space -- ��־�ռ�  
with primary key;     -- ָ��Ϊ��������
 
--��Ŀ�����ݿ��ϴ���MATERIALIZED VIEW��
create materialized view mv_materialized_test 
refresh force on demand start with sysdate next
to_date(concat(to_char(sysdate+1,'dd-mm-yyyy'),'10:25:00'),'dd-mm-yyyy hh24:mi:ss') as
select * from user_info; 
--����ﻯ��ͼ��ÿ��10��25����ˢ�� 
 
--�޸�ˢ��ʱ�䣺
alter materialized view mv_materialized_test refresh force on demand start with sysdate 
next to_date(concat(to_char(sysdate+1,'dd-mm-yyyy'),' 23:00:00'),'dd-mm-yyyy hh24:mi:ss');
--��
alter materialized view mv_materialized_test refresh force on demand start with sysdate 
next trunc(sysdate,'dd')+1+1/24; -- ÿ��1��ˢ�� 

--����������
create index IDX_MMT_IU_TEST
on mv_materialized_test(ID,UNAME)  
tablespace test_space; 

--ɾ���ﻯ��ͼ����־��
drop materialized view log on test_table;    --ɾ���ﻯ��ͼ��־�� 
drop materialized view mv_materialized_test; --ɾ���ﻯ��ͼ  
-------------------------------------------------------------
-- �ﻯ��ͼ���ϵͳ�ֵ��
select * from user_mview_aggregates;
select * from user_mview_analysis;
select * from user_mview_comments;
select * from user_mview_detail_partition;
select * from user_mview_detail_relations;
select * from user_mview_detail_subpartition;
select * from user_mview_joins;
select * from user_mview_keys;
select * from user_mview_logs;
select * from user_mviews;
select * from user_mview_refresh_times;

select * from user_tables order by table_name;
