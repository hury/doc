/*
2016-04-20 15:47:12 @hury
Oracle表分区算法
参考：
http://love-flying-snow.iteye.com/blog/573303
http://blog.itpub.net/21251711/viewspace-1119937/
http://blog.chinaunix.net/uid-23284114-id-3304525.html
http://blog.csdn.net/hijiankang/article/details/9173877/
http://blog.csdn.net/tianlesoftware/article/details/5134819
http://www.blogjava.net/rabbit/archive/2013/01/08/393955.html
*/
---------------------------------------------------------
create tablespace ts_test logging datafile 'D:\database\ehrview\ts_test.dbf' size 10m autoextend on next 10m maxsize 32767m extent management local;
---------------------------------------------------------
-- 1、范围分区
create table a01
(
  id int,
  name varchar2(20),
  grade int
) partition by range(grade)
(
  partition g1 values less than (100),
  partition g2 values less than (200),
  partition g3 values less than (maxvalue)
);
delete from a01;

insert into a01 (id, name, grade) values(1,'h1',11);
insert into a01 (id, name, grade) values(2,'h2',101);
insert into a01 (id, name, grade) values(3,'h3',201);
commit;

select * from a01;
select * from a01 partition(g1);
select * from a01 partition(g2);
select * from a01 partition(g3);
---------------------------------------------------------
-- 2、散列分区 
create table a02
(
  id int,
  name varchar2(20),
  grade int
) partition by hash(id)
(
  partition g1 ,
  partition g2 ,
  partition g3 
);

insert into a02 (id, name, grade) values(1,'h1',11);
insert into a02 (id, name, grade) values(2,'h2',101);
insert into a02 (id, name, grade) values(3,'h3',201);
commit;

select * from a02;
select * from a02 partition(g1);
select * from a02 partition(g2);
select * from a02 partition(g3);

---------------------------------------------------------
-- 3、列表分区 
drop table a03;
create table a03
(
  id int,
  name varchar2(20),
  grade int
) partition by list(grade)
(
  partition g1  values(1),
  partition g2  values(2),
  partition g3  values(3),
  partition g4 values(default)
);

insert into a03 (id, name, grade) values(1,'h1',1);
insert into a03 (id, name, grade) values(2,'h2',2);
insert into a03 (id, name, grade) values(3,'h3',3);
insert into a03 (id, name, grade) values(4,'h4',4);
insert into a03 (id, name, grade) values(5,'h5',5);
commit;

select * from a03;
select * from a03 partition(g1);
select * from a03 partition(g2);
select * from a03 partition(g3);
select * from a03 partition(g4);

---------------------------------------------------------
-- 4、复合分区 

-- 范围-散列
create table a04
(
  id int,
  name varchar2(20),
  grade int
) partition by range(grade)
subpartition by hash(id)
(
  partition g1  values less than (75) (subpartition sg1, subpartition sg2),
  partition g3  values less than (maxvalue ) (subpartition sg3, subpartition sg4)
);

insert into a04 (id, name, grade) values(1,'h1',1);
insert into a04 (id, name, grade) values(2,'h2',75);
insert into a04 (id, name, grade) values(3,'h3',76);
commit;

select * from a04;
select * from a04 partition(g1);
select * from a04 partition(g3);
select * from a04 subpartition(sg1);
select * from a04 subpartition(sg2);
select * from a04 subpartition(sg3);
select * from a04 subpartition(sg4);

---------------------------------------------------------
-- 5、间隔分区 Interval Partitioning 
-- 基于Range和List的Interval Partitioning分区类型登场。 
CREATE TABLE C1(
ID INT,
TIME_COL DATE
)
PARTITION BY RANGE (time_col)
INTERVAL(NUMTOYMINTERVAL(1, 'month'))
(PARTITION P0 VALUES LESS THAN (TO_DATE('1-1-2010', 'dd-mm-yyyy'))); 

-- 写入测试数据
begin
  for i in 0 .. 11 loop
    insert into c1
      (id, time_col)
    values
      (i, add_months(to_date('2008-01-01', 'yyyy-mm-dd'), i));
  end loop;
  COMMIT;
end;

select * from user_tab_partitions where table_name= 'C1' ORDER BY PARTITION_NAME

CALL DBMS_STATS.gather_table_stats('EHRVIEW','C1');

SELECT * FROM C1 
WHERE TIME_COL >=to_date('2010-02-01','yyyy-mm-dd')
    AND TIME_COL <  to_date('2010-04-01','yyyy-mm-dd')


---------------------------------------------------------
-- 6、虚拟列分区
drop table a05;
create table a05
(
  id int,
  name varchar2(20),
  time_col date,
  tc_year as (extract (year from time_col)),
  tc_month as (extract (month from time_col)),
  tc_day as (extract (day from time_col))
) partition by list(tc_year)
(
  partition ts_2011 values  (2011)  tablespace ts_test,
  partition ts_2012 values  (2012)  tablespace ts_test,
  partition ts_2013 values  (2013)  tablespace ts_test,
  partition ts_max values (default)  tablespace ts_test
);

insert into a05 (id, name, time_col) values(1,'h1',to_date('2011-01-01','yyyy-mm-dd'));
insert into a05 (id, name, time_col) values(2,'h2',to_date('2012-01-01','yyyy-mm-dd'));
insert into a05 (id, name, time_col) values(3,'h3',to_date('2013-01-01','yyyy-mm-dd'));
insert into a05 (id, name, time_col) values(4,'h4',to_date('2014-01-01','yyyy-mm-dd'));
insert into a05 (id, name, time_col) values(5,'h5',to_date('2015-01-01','yyyy-mm-dd'));
commit;

select * from a05;
select * from a05 partition(ts_2011);
select * from a05 partition(ts_2012);
select * from a05 partition(ts_2013);
select * from a05 partition(ts_max);

-- 列表分区含有default，分区分裂方式如下：
alter table a05 split partition ts_max values(2014) into (partition ts_2014, partition ts_max);

select * from a05 partition(ts_2014);
select * from a05 partition(ts_max);

/*
 分区查询性能分析
 分区键为虚拟键，根据"业务时间"生成。统计计算时需要使用分区键做谓词才能够使用分区排除；
 如果使用"业务时间"做谓词，无法获得分区排除的优势。
*/
select * from a05 where time_col=to_date('2013-01-01','yyyy-mm-dd');
select * from a05 where tc_year=2013;


---------------------------------------------------------
-- 分区的维护操作
--1、分裂分区-范围分区
alter table a01 split partition g1 at(75) into (partition g1_low, partition g1_high);
alter table a01 split partition g3 at(300) into (partition g3, partition gmax);
      
select * from a01;
select * from a01 partition(g1);
select * from a01 partition(g2);
select * from a01 partition(g3);
select * from a01 partition(g4);
select * from a01 partition(gmax);
select * from a01 partition(g1_low);
select * from a01 partition(g1_high);

insert into a01 (id, name, grade) values(3,'h3',80);
insert into a01 (id, name, grade) values(4,'h4',280);
insert into a01 (id, name, grade) values(5,'h5',400);
commit;

select * from user_tab_partitions where table_name = 'A01';
alter table a01 add partition gmax  values less than (maxvalue);
alter table a01 split partition gmax at(300) into (partition g3, partition gmax);
alter table a01 split partition gmax at(500) into (partition g4, partition gmax);

---------------------------------------------------------
alter table MS_GHMX split partition ts_2011 at (to_date('2011-04-01','yyyy-mm-dd')) into (partition ts_2011_01 tablespace ts_2011_01, partition ts_2011);

---------------------------------------------------------

-- 2、合并分区
alter table a01 merge partitions g1_low, g1_high
into partition g1;

-- 3、添加分区
alter table a02 add partition g4;

insert into a02 (id, name, grade) values(4,'h4',201);
insert into a02 (id, name, grade) values(5,'h5',201);
insert into a02 (id, name, grade) values(6,'h6',201);
commit;

select * from a02;
select * from a02 partition(g1);
select * from a02 partition(g2);
select * from a02 partition(g3);
select * from a02 partition(g4);

-- 4、删除分区
alter table a01 drop partition g3;

select * from a01 partition(g1);
select * from a01 partition(g2);
select * from a01 partition(g3);

-- 5、截断分区，清空分区中的数据
alter table a01 truncate partition g1;
