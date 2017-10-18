/*
2016-8-30 15:57:23 @hury
表分区扩展分析
*/
-- 创建测试表
create table test_partition(
id int,
name varchar(10),
ghsj date
)
  PARTITION BY range (ghsj) (
  PARTITION ts_2016_04 VALUES less than (to_date('2017-01-01','yyyy-mm-dd')) tablespace ts_2016_04, 
  PARTITION ts_max VALUES less than (maxvalue) tablespace ts_max
)
;

-- 插入数据
insert into test_partition(id,name,ghsj) values(1,'a1',to_date('2016-12-01', 'yyyy-mm-dd'));
insert into test_partition(id,name,ghsj) values(12,'a12',to_date('2017-01-01', 'yyyy-mm-dd'));
commit;

-- 测试数据读取
select * from test_partition partition(ts_2016_04);
select * from test_partition partition(ts_max);
select * from test_partition;

------------------------------------------------
-- 新增分区
alter table test_partition split partition ts_max at (to_date('2017-04-01','yyyy-mm-dd')) into (partition TS_2017_01 tablespace TS_2017_01, partition ts_max);

-- 插入数据
insert into test_partition(id,name,ghsj) values(21,'a21',to_date('2017-01-01', 'yyyy-mm-dd'));
insert into test_partition(id,name,ghsj) values(22,'a22',to_date('2017-02-01', 'yyyy-mm-dd'));
insert into test_partition(id,name,ghsj) values(23,'a23',to_date('2017-03-01', 'yyyy-mm-dd'));
insert into test_partition(id,name,ghsj) values(24,'a24',to_date('2017-04-01', 'yyyy-mm-dd'));
commit;

-- 测试数据读取
select * from test_partition partition(ts_2016_04);
select * from test_partition partition(TS_2017_01);
select * from test_partition partition(ts_max);
