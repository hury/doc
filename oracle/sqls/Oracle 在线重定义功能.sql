/*
2016-04-21 11:56:23 @hury
�����ض��幦��
��;�����ڽ���ͨ���޸�Ϊ������
*/

-- ԭʼ��ṹ
DROP TABLE B01;
CREATE TABLE B01 (
ID NUMBER , 
TIME DATE ,
CONSTRAINT PK_B01 PRIMARY KEY(ID)
);
create index idx_b01_time on b01(time);

-- ��������
INSERT INTO B01 select rownum, created from dba_objects;
commit;
select * from b01;

-- �����±�ṹ
DROP TABLE B01_NEW;
CREATE TABLE B01_NEW (
ID NUMBER , 
TIME DATE ,
CONSTRAINT PK_B01_NEW PRIMARY KEY(ID)
) PARTITION BY RANGE (TIME) (
PARTITION P1 VALUES LESS THAN (TO_DATE('2011-01-01','YYYY-MM-DD')),
PARTITION P2 VALUES LESS THAN (TO_DATE('2017-01-01','YYYY-MM-DD'))
)

-------------------------------------------
-- step 1 ����
CALL DBMS_REDEFINITION.can_redef_table('EHRVIEW','B01');

-- step 2 ����ʼ�ض���
CALL DBMS_REDEFINITION.start_redef_table('EHRVIEW','B01','B01_NEW');

-- step 3 ��ͬ���м����ԭʼ��
call dbms_redefinition.sync_interim_table('EHRVIEW','B01','B01_NEW');

-- step 4�������ض���
call dbms_redefinition.finish_redef_table('EHRVIEW','B01','B01_NEW');

----------------------------------------------------------
SELECT * FROM B01_NEW;
SELECT * FROM B01_NEW PARTITION(P1);
SELECT * FROM B01_NEW PARTITION(P2);

SELECT * FROM B01;
SELECT * FROM B01 PARTITION(P1);
SELECT * FROM B01 PARTITION(P2);


SELECT EXTRACT(YEAR FROM TIME),COUNT(1)  FROM B01
GROUP BY EXTRACT(YEAR FROM TIME);

/*EXTRACT(YEARFROMTIME)	COUNT(1)
2010	71812
2016	1213
*/
