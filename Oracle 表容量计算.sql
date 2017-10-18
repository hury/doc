/*
Oracle ����������
����ÿ�ű���̿ռ�ռ�����������ÿ����¼�Ĵ�С��
*/
select a.table_name as "����"
       , a.num_rows as "������"
       , cast(a.bytes / 1024/1024 as number(18,2)) as "�ܴ��̿ռ䣨M��"
       , cast(a.bytes / 1024/1024/1024 as number(18,2)) as "�ܴ��̿ռ䣨G��"
       , case when a.num_rows>0 then cast(a.bytes /a.num_rows as number(18,2)) else 0 end as "ÿ����¼ռ�ÿռ䣨bytes��"
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
