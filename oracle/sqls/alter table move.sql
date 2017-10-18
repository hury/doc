Oracle表移动CLOB表空间

参考：
http://www.cnblogs.com/Cratical/archive/2010/08/24/1806948.html
http://www.itpub.net/thread-1402010-1-1.html

-- compress
--高水位以下合并碎片，不移动高水位
alter table xxx move;    

--高水位以下合并碎片，不移动高水位, 同时压缩表
alter table xxx move compress for all operations;    

-- shrink
--  限制条件：
1、不能对cluster、clustered  table 或者任何有LONG列的对象使用这个语句
2、压缩段不支持有函数索引、位图链接索引的表
3、这语句不能压缩二级索引表的映射表，即使设置了CASCADE
4、不能对压缩表使用该语句
5、不能压缩on commit 类型的物化视图的主表，rowid物化视图必须在压缩操作之后重建

-- 启用行移动
alter table xxx enable row movement;
--高水位上下合并碎片，降低高水位，相关索引也要收缩一下下
alter table xxx shrink space cascade;  

-- Oracle表移动表空间：
alter table tb_name move tablespace tbs_name;
--移动lob字段数据:
alter table tb_name move tablespace tbs_name lob (col_lob1,col_lob2) store as(tablesapce tbs_name);

-- move过的普通表，在不用到失效的索引的操作语句中，语句执行正常，但如果操作的语句用到了索引（主键当做唯一索引），
-- 则此时报告用到的索引失效，语句执行失败，其他如外键，非空约束，缺省值等不会失效。

-- 我们需要重新创建主键或索引，基本语法为：
alter index index_name rebuild;
alter index pk_name rebuild;

--如果我们需要move索引，则使用rebuild语法：
alter index index_name rebuild tablespace tbs_name;
alter index pk_name rebuild tablespace tbs_name;

--二：move分区表及索引和普通表一样，索引会失效，区别的仅仅是语法而已。

--分区基本语法：特别提醒注意，如果是单级分区，则使用关键字PARTITION，如果是多级分区，则使用SUBPARTITION替代PARTITION。

--如果分区或分区索引比较大，可以使用并行move或rebuild，PARALLEL (DEGREE 2);如：
ALTER TABLE PART_ALARMTEXTDATA move SUBPARTITION ALARMTEXTDATA_050910_ATD01 TABLESPACE users PARALLEL (DEGREE 2);
ALTER INDEX GLOBAL_ALARMTEXTDATA REBUILD tablespace users PARALLEL (DEGREE 2);
ALTER INDEX LOCAL_ALARMTEXTDATA REBUILD SUBPARTITION ALARMTEXTDATA_050910_ATD01 TABLESPACE users PARALLEL (DEGREE 2);

--移动表的某个分区：
ALTER TABLE tab_name move PARTITION partition_name TABLESPACE tbs_name;

--重建全局索引：
ALTER INDEX global_index REBUILD;或
ALTER INDEX global_index REBUILD tablespace tbs_name;

注: 分区操作时可以带上with update global indexes选项更新全局索引

-- 重建局部索引：
ALTER TABLE tab_name MODIFY PARTITION partition_name REBUILD UNUSABLE LOCAL INDEXES;
ALTER INDEX local_index_name REBUILD PARTITION partition_name TABLESPACE tbs_name;

提示：
USER_PART_TABLES
USER_IND_PARTITIONS
USER_IND_SUBPARTITIONS
USER_LOB_PARTITIONS
USER_LOB_SUBPARTITIONS
USER_PART_INDEXES
USER_PART_LOBS可查询分区相关内容，同时，分区对象，也是segment，所以也可在dba_segments里查的到。

