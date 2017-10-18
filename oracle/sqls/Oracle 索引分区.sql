/*Oracle 索引分区*/
-- 查看分区索引
select * 
from user_ind_partitions a, user_indexes b
where a.index_name = b.index_name 
      and b.table_name = 'YS_MZ_JZLS'

-- 查看非分区索引
select * from user_indexes 
where table_name = 'YS_MZ_JZLS'
order by index_name;
