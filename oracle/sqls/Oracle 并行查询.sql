2017-08-14 14:41:21 @hury
�ο���http://blog.csdn.net/zengmingen/article/details/51026930

Oracle ���в�ѯ 

��ν����ִ�У���ָ�ܹ���һ�����ʹ��������κ�DML��һ���DDL������Ļ���Ϊ�ж��С�Ĳ��֣���Щ��С�Ĳ��ֿ���ͬʱ�õ�����

��ʱʹ�ò���ִ��:
1��������һ���ǳ��������

2�������г������Դ��CPU,I/O,MEMORY��


���в�ѯ

���в�ѯ����һ��SQL SELECT ��仮��Ϊ�����С�Ĳ�ѯ��ÿ����ѯ���������С����ÿ����С��ѯ�õ��Ľ������������õ����ս����

�������в�ѯ���ַ�ʽ��

1���ڲ�ѯ��ʹ��һ��hint��ʾ��select /*+ parallel(4)  */  count(*)  from test_a ;---ָ��һ�����ж�Ϊ4�Ĳ��в�ѯ��

2������alter table�޸ı�

alter table test_a parallel 4;--����oracle���ڴ���������ִ�мƻ�ʱ��ʹ�ò��ж�4

alter table test_a parallel;
-- ����oracel�����뿼�ǲ���ִ�С���Oracle �����ϵͳ�������غͲ�ѯ������ȷ���ʵ��Ĳ��жȡ���Դ���㣬���ж���������Դϡȱ�����ж��½���
-- oracle�ܶ�̬�����ӻ���ٲ�ѯ����Ҫ�Ĳ�����Դ���� ��ϲ���ô��ַ�ʽ�������в�ѯ��

------------------------------------------------------------
-- ����ʵ��
create table tmp_20170814(
id number(8) primary key,
name varchar2(20)
);

insert into tmp_20170814(id,name) values(1,'hury');
commit;

alter table tmp_20170814 parallel ;

-- ��������parallel
select 'ALTER TABLE '|| A.TABLE_NAME ||' PARALLEL;', a.table_name, a.num_rows
from  user_tables a
where a.num_rows > 50000
order by a.num_rows desc nulls last;