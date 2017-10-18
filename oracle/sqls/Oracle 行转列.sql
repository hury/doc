/*
oracle��ת��
listagg(column,'�ָ���') within group (order by column) over(partition by column)
*/
select a.cfsb, listagg(c.ypmc, ',') within group(order by c.ypmc) as ypmc
  FROM ms_cf01 a, MS_CF02 c
 where a.cfsb = c.cfsb
   and a.kettle_code = c.kettle_code
   and a.kettle_code = 'azsqwsfwzx'
   and a.brid = 6894
 group by a.cfsb
;

select a.cfsb, wm_concat(c.ypmc) as ypmc
  FROM ms_cf01 a, MS_CF02 c
 where a.cfsb = c.cfsb
   and a.kettle_code = c.kettle_code
   and a.kettle_code = 'azsqwsfwzx'
   and a.brid = 6894
 group by a.cfsb
 
--------------------------------------------------------------------------------------------
/*
��oracle 11g release 2 �汾��������listagg������listagg��һ��ʵ���ַ����ۺϵ�oracle�ڽ�����;
listagg(column,'�ָ���') within group (order by column) over(partition by column)
�ָ�������Ϊ�գ�
order by��ѡ�����order by null

(1)select status,  listagg(risk_id, ',') within group (order by risk_id) from rp_risk group by status;
��status���飬��risk_idȫ���ϲ���ʾ��һ��
(2)�����ľۺϺ������ƣ�listaggͨ������over()�Ӿ����ʵ�ַ�������
select risk_id, status, listagg(risk_id, ',') within group (order by risk_id) over(partition by status) from rp_risk;
ѡ���뵱ǰrisk_id��ͬһ�����ŵ�����risk_id���ϲ��ַ���
(3)listagg�ۺϵĽ���д�С������varchar2���͵����ֵ�ڣ�����4000);
(4)�ϲ��ַ���Ҳ������wm_concat(column_name),���а汾��oracle���������������
��listagg()��oracle 11g release 2���У�
(5)�ο�����
http://xpchild.blog.163.com/blog/static/10180985920108485721969/
*/
