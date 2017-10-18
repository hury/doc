2017-08-14 14:41:21 @hury
参考：http://blog.csdn.net/zengmingen/article/details/51026930

Oracle 并行查询 

所谓并行执行，是指能够将一个大型串行任务（任何DML，一般的DDL）物理的划分为叫多个小的部分，这些较小的部分可以同时得到处理。

何时使用并行执行:
1、必须有一个非常大的任务

2、必须有充足的资源（CPU,I/O,MEMORY）


并行查询

并行查询允许将一个SQL SELECT 语句划分为多个较小的查询，每个查询并发的运行。最后将每个较小查询得到的结果组合起来，得到最终结果。

启动并行查询几种方式：

1、在查询中使用一个hint提示：select /*+ parallel(4)  */  count(*)  from test_a ;---指定一个并行度为4的并行查询。

2、利用alter table修改表：

alter table test_a parallel 4;--告诉oracle，在创建这个表的执行计划时，使用并行度4

alter table test_a parallel;
-- 告诉oracel，“请考虑并行执行。”Oracle 会根据系统工作负载和查询本身来确定适当的并行度。资源充足，并行度上升，资源稀缺，并行度下降。
-- oracle能动态的增加或减少查询所需要的并发资源量。 更喜欢用此种方式启动并行查询。

------------------------------------------------------------
-- 并行实践
create table tmp_20170814(
id number(8) primary key,
name varchar2(20)
);

insert into tmp_20170814(id,name) values(1,'hury');
commit;

alter table tmp_20170814 parallel ;

-- 批量启用parallel
select 'ALTER TABLE '|| A.TABLE_NAME ||' PARALLEL;', a.table_name, a.num_rows
from  user_tables a
where a.num_rows > 50000
order by a.num_rows desc nulls last;