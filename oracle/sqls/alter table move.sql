Oracle���ƶ�CLOB��ռ�

�ο���
http://www.cnblogs.com/Cratical/archive/2010/08/24/1806948.html
http://www.itpub.net/thread-1402010-1-1.html

-- compress
--��ˮλ���ºϲ���Ƭ�����ƶ���ˮλ
alter table xxx move;    

--��ˮλ���ºϲ���Ƭ�����ƶ���ˮλ, ͬʱѹ����
alter table xxx move compress for all operations;    

-- shrink
--  ����������
1�����ܶ�cluster��clustered  table �����κ���LONG�еĶ���ʹ��������
2��ѹ���β�֧���к���������λͼ���������ı�
3������䲻��ѹ�������������ӳ�����ʹ������CASCADE
4�����ܶ�ѹ����ʹ�ø����
5������ѹ��on commit ���͵��ﻯ��ͼ������rowid�ﻯ��ͼ������ѹ������֮���ؽ�

-- �������ƶ�
alter table xxx enable row movement;
--��ˮλ���ºϲ���Ƭ�����͸�ˮλ���������ҲҪ����һ����
alter table xxx shrink space cascade;  

-- Oracle���ƶ���ռ䣺
alter table tb_name move tablespace tbs_name;
--�ƶ�lob�ֶ�����:
alter table tb_name move tablespace tbs_name lob (col_lob1,col_lob2) store as(tablesapce tbs_name);

-- move������ͨ���ڲ��õ�ʧЧ�������Ĳ�������У����ִ�����������������������õ�����������������Ψһ��������
-- ���ʱ�����õ�������ʧЧ�����ִ��ʧ�ܣ�������������ǿ�Լ����ȱʡֵ�Ȳ���ʧЧ��

-- ������Ҫ���´��������������������﷨Ϊ��
alter index index_name rebuild;
alter index pk_name rebuild;

--���������Ҫmove��������ʹ��rebuild�﷨��
alter index index_name rebuild tablespace tbs_name;
alter index pk_name rebuild tablespace tbs_name;

--����move��������������ͨ��һ����������ʧЧ������Ľ������﷨���ѡ�

--���������﷨���ر�����ע�⣬����ǵ�����������ʹ�ùؼ���PARTITION������Ƕ༶��������ʹ��SUBPARTITION���PARTITION��

--�����������������Ƚϴ󣬿���ʹ�ò���move��rebuild��PARALLEL (DEGREE 2);�磺
ALTER TABLE PART_ALARMTEXTDATA move SUBPARTITION ALARMTEXTDATA_050910_ATD01 TABLESPACE users PARALLEL (DEGREE 2);
ALTER INDEX GLOBAL_ALARMTEXTDATA REBUILD tablespace users PARALLEL (DEGREE 2);
ALTER INDEX LOCAL_ALARMTEXTDATA REBUILD SUBPARTITION ALARMTEXTDATA_050910_ATD01 TABLESPACE users PARALLEL (DEGREE 2);

--�ƶ����ĳ��������
ALTER TABLE tab_name move PARTITION partition_name TABLESPACE tbs_name;

--�ؽ�ȫ��������
ALTER INDEX global_index REBUILD;��
ALTER INDEX global_index REBUILD tablespace tbs_name;

ע: ��������ʱ���Դ���with update global indexesѡ�����ȫ������

-- �ؽ��ֲ�������
ALTER TABLE tab_name MODIFY PARTITION partition_name REBUILD UNUSABLE LOCAL INDEXES;
ALTER INDEX local_index_name REBUILD PARTITION partition_name TABLESPACE tbs_name;

��ʾ��
USER_PART_TABLES
USER_IND_PARTITIONS
USER_IND_SUBPARTITIONS
USER_LOB_PARTITIONS
USER_LOB_SUBPARTITIONS
USER_PART_INDEXES
USER_PART_LOBS�ɲ�ѯ����������ݣ�ͬʱ����������Ҳ��segment������Ҳ����dba_segments���ĵ���

