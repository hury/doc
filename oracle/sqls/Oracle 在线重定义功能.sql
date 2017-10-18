/*
2016-04-21 11:56:23 @hury
在线重定义功能
用途：用于将普通表，修改为分区表
*/

-- 原始表结构
DROP TABLE B01;
CREATE TABLE B01 (
ID NUMBER , 
TIME DATE ,
CONSTRAINT PK_B01 PRIMARY KEY(ID)
);
create index idx_b01_time on b01(time);

-- 测试数据
INSERT INTO B01 select rownum, created from dba_objects;
commit;
select * from b01;

-- 定义新表结构
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
-- step 1 评估
CALL DBMS_REDEFINITION.can_redef_table('EHRVIEW','B01');

-- step 2 、开始重定义
CALL DBMS_REDEFINITION.start_redef_table('EHRVIEW','B01','B01_NEW');

-- step 3 、同步中间表与原始表
call dbms_redefinition.sync_interim_table('EHRVIEW','B01','B01_NEW');

-- step 4、结束重定义
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
