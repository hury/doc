-- 2015-12-16 14:53:59 @hury
-- ���ֶ�Ϊxml�����ݣ�����Ϊ��ά��
select * from (
select  extractValue(value(m), '/DiabetesRecords/MDC_DIABETESRECORD/MANAUNITID') AS MANAUNITID
from contentdata t
     , table( xmlsequence(extract(XMLTYPE(t.content_xml),'/DiabetesRecords'))) m 
where t.recordtype=4 
and t.kettle_lastmodify > to_date('2015-12-01','yyyy-mm-dd')
) a 
