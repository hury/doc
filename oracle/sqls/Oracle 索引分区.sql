/*Oracle ��������*/
-- �鿴��������
select * 
from user_ind_partitions a, user_indexes b
where a.index_name = b.index_name 
      and b.table_name = 'YS_MZ_JZLS'

-- �鿴�Ƿ�������
select * from user_indexes 
where table_name = 'YS_MZ_JZLS'
order by index_name;
