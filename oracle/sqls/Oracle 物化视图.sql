/*
2016-7-13 11:01:57 @hury
物化视图
参考：http://www.cnblogs.com/Ronger/archive/2012/03/28/2420962.html
*/

/*
 1、物化视图的类型：ON DEMAND、ON COMMIT 
 二者的区别在于刷新方法的不同，
 ON DEMAND顾名思义，仅在该物化视图“需要”被刷新了，才进行刷新(REFRESH)，即更新物化视图，以保证和基表数据的一致性；
 ON COMMIT是说，一旦基表有了COMMIT，即事务提交，则立刻刷新，立刻更新物化视图，使得数据和基表一致。
*/

-- 2、ON DEMAND物化视图    
-- 原始表
select * from organ_compare;

-- 物化视图 明细
create materialized view mv_organ_compare 
refresh complete ON DEMAND as
select * from organ_compare;

-- 删除物化视图
drop materialized view mv_organ_compare ;

-- 物化视图 统计
create materialized view mv_organ_compare_cnt as
select parentcode, parentname,count(1) as sl 
from organ_compare group by parentcode, parentname;

--完全刷新
BEGIN
     DBMS_MVIEW.REFRESH('MV_ORGAN_COMPARE','C');
END;

-- 3、ON COMMIT物化视图
-- 创建ON COMMIT物化视图：
-- 备注：实际创建过程中，基表需要有主键约束，否则会报错（ORA-12014） 
create materialized view mv_name refresh force on commit as select * from table_name    
 
 
---------------------------------------------
select * from systemusers;

--创建物化视图日志
create materialized view log on systemusers;  
create materialized view mv_systemusers as select * from systemusers;

select * from mv_systemusers;

--快速刷新，也就是增量刷新
begin
dbms_mview.refresh('MV_SYSTEMUSERS', 'F');
end;
-------------------------------------------------------------

--创建物化视图需要的权限：
grant create materialized view to user_name; 
 
--在源表建立物化视图日志：
create materialized view log on test_table  
tablespace test_space -- 日志空间  
with primary key;     -- 指定为主键类型
 
--在目标数据库上创建MATERIALIZED VIEW：
create materialized view mv_materialized_test 
refresh force on demand start with sysdate next
to_date(concat(to_char(sysdate+1,'dd-mm-yyyy'),'10:25:00'),'dd-mm-yyyy hh24:mi:ss') as
select * from user_info; 
--这个物化视图在每天10：25进行刷新 
 
--修改刷新时间：
alter materialized view mv_materialized_test refresh force on demand start with sysdate 
next to_date(concat(to_char(sysdate+1,'dd-mm-yyyy'),' 23:00:00'),'dd-mm-yyyy hh24:mi:ss');
--或
alter materialized view mv_materialized_test refresh force on demand start with sysdate 
next trunc(sysdate,'dd')+1+1/24; -- 每天1点刷新 

--建立索引：
create index IDX_MMT_IU_TEST
on mv_materialized_test(ID,UNAME)  
tablespace test_space; 

--删除物化视图及日志：
drop materialized view log on test_table;    --删除物化视图日志： 
drop materialized view mv_materialized_test; --删除物化视图  
-------------------------------------------------------------
-- 物化视图相关系统字典表
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
