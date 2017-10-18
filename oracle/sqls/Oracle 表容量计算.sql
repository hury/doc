/*
Oracle 表容量计算
计算每张表磁盘空间占用情况，评估每条记录的大小。
*/
select a.table_name as "表名"
       , a.num_rows as "总行数"
       , cast(a.bytes / 1024/1024 as number(18,2)) as "总磁盘空间（M）"
       , cast(a.bytes / 1024/1024/1024 as number(18,2)) as "总磁盘空间（G）"
       , case when a.num_rows>0 then cast(a.bytes /a.num_rows as number(18,2)) else 0 end as "每条记录占用空间（bytes）"
from (
  select a.table_name
         , a.num_rows
         , sum(bytes) as bytes
  from user_tables a
    ,(
    select table_name, segment_name from user_lobs union all
    select table_name, index_name as segment_name from user_indexes  union all
    select table_name, table_name as segment_name from user_tables
    ) b
    , user_segments c
  where a.table_name = b.table_name
        and b.segment_name = c.segment_name
  group by a.table_name
         , a.num_rows
) a
where a.table_name like '%2D'
order by 1 desc 
