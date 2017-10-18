Oracle 表缓存(caching table)的使用 

参考：http://blog.csdn.net/leshami/article/details/6226767

--************************************

-- Oracle 表缓存(caching table)的使用

--************************************

 

1.使用caching table 的原因

        在通常的情况下，应用程序访问在cache中的数据块将按照LRU算法来进行处理。然而对于小表的访问，当使用全表扫描时，则该表

    中的块会放置LRU列表最近最少使用尾部的(LRU端)，因此很快就被淘汰出局。然而使用基于成本优化的方法，对于小表进行查询以及收

    集统计信息，大多情形下走的是全表扫描，因此势必造成一种情形，即该表后续需要再次访问，而每次使用了全表扫描，而该对象很快

    被淘汰出局，因此需要再次读入到buffer cache，耗用了大量的I/O。

           

2.解决该问题的方法

    设计表为caching table ，即使对该表使用全表访问时，则该表对象的块仍然被放置在LRU列表最近最多使用的尾部(MRU段)

    不要过度的使用caching table，以免造成性能下降

    通常将caching table 存放在keep buffer pool，缺省的情况下会放置在default buffer pool。

   

3.具有cache属性与pin 的差异

    对于具有cache属性的对象，并不是将该对象pin到cache里，而是尽可能的延迟该对象驻留cache的时间

    而对于pin对象，则是将该对象常驻到内存

   

4.设计cache table 的方法

    创建表对象时，使用cache子句

    修改表对象时，使用cache子句

    使用cache 提示

   

    创建表对象时使用cache，如下面的例子

        create table tb_test

        (id number

         ,name varchar2(20)

         ,sex  char(1)

         ,age  number

         ,score number)

         tablespace users

         storage(initial 50k next 50k pctincrease 0)

         cache;    --指定cache子句

 

     使用alter table 修改已经存在的表

        alter table scott.emp cache;

       

     可以使用nocache来修改对象，使其不具备cache属性

        alter table soctt.emp nocache

       

     使用hint提示符来实现cache

        select /*+ cache*/ empno,ename from scott.emp;

   

5.使用例子演示caching table情形

 

    scott@ORCL> create table tb1 nologging

      2  as select level id,rpad('*',4000,'*') data,rpad('*',2000,'*') data2

      3  from dual

      4  connect by level <= 15000;

 

    Table created. 

 

    scott@ORCL> create table tb2

      2  cache nologging

      3  as select level id,rpad('*',4000,'*') data,rpad('*',2000,'*') data2

      4  from dual

      5  connect by level <= 15000;

 

    Table created.

 

    scott@ORCL> select count(1) from tb1;

 

      COUNT(1)

    ----------

         15000

 

    scott@ORCL> select count(1) from tb2;

 

      COUNT(1)

    ----------

         15000

 

    scott@ORCL> select table_name,num_rows,cache from user_tables where table_name in ('TB1','TB2');

 

    TABLE_NAME        NUM_ROWS CACHE

    --------------- ---------- -----

    TB1                  15000     N

    TB2                  15000     Y

         

    scott@ORCL> set autotrace traceonly statistics;

    scott@ORCL> select count(1) from tb1;

 

    Statistics

    ----------------------------------------------------------

              5  recursive calls

              0  db block gets

          15086  consistent gets

          15000  physical reads

              0  redo size

            412  bytes sent via SQL*Net to client

            385  bytes received via SQL*Net from client

              2  SQL*Net roundtrips to/from client

              0  sorts (memory)

              0  sorts (disk)

              1  rows processed

             

    scott@ORCL> select count(1) from tb1;

 

    Statistics

    ----------------------------------------------------------

              0  recursive calls

              0  db block gets

          15011  consistent gets

          15000  physical reads

              0  redo size

            412  bytes sent via SQL*Net to client

            385  bytes received via SQL*Net from client

              2  SQL*Net roundtrips to/from client

              0  sorts (memory)

              0  sorts (disk)

              1  rows processed    

 

    scott@ORCL> select count(1) from tb2;

 

    Statistics

    ----------------------------------------------------------

              0  recursive calls

              0  db block gets

          15011  consistent gets

            197  physical reads

              0  redo size

            412  bytes sent via SQL*Net to client

            385  bytes received via SQL*Net from client

              2  SQL*Net roundtrips to/from client

              0  sorts (memory)

              0  sorts (disk)

              1  rows processed

 

    scott@ORCL> select count(1) from tb2;

 

    Statistics

    ----------------------------------------------------------

              0  recursive calls

              0  db block gets

          15011  consistent gets

              0  physical reads

              0  redo size

            412  bytes sent via SQL*Net to client

            385  bytes received via SQL*Net from client

              2  SQL*Net roundtrips to/from client

              0  sorts (memory)

              0  sorts (disk)

              1  rows processed      

   

        从上面的示例中可以看出，表tb1每次都将使用相同的物理读，而表tb2一旦被load进buffer cache中，始终处于LRU的MRU端，尽可能的

    避免因buffer cache过小而被置换到buffer cache之外。

        注意不同的演示环境可能有所差异，本人的演示环境如下;

            scott@ORCL> show parameter sga_

 

            NAME                                 TYPE        VALUE

            ------------------------------------ ----------- ------------------------------

            sga_max_size                         big integer 264M

            sga_target                           big integer 264M

            scott@ORCL> select * from v$version;

 

            BANNER

            ----------------------------------------------------------------

            oracle Database 10g Enterprise Edition Release 10.2.0.1.0 - Prod

            PL/SQL Release 10.2.0.1.0 - Production

            CORE    10.2.0.1.0      Production

            TNS for Linux: Version 10.2.0.1.0 - Production

            NLSRTL Version 10.2.0.1.0 - Production         

         

6.注意cache table与keep buffer pool的异同

    两者的目的都是尽可能将最热的对象置于到buffer pool，尽可能的避免aged out。

    cache table是将对象置于到default buffer cache。

    而使用buffer_pool keep子句是将对象置于到keep buffer pool。

    当buffer_pool和cache同时指定时，keep比cache有优先权。buffer_pool用来指定存贮使用缓冲池，而cache/nocache指定存储的

    方式(LRU或MRU端)。建表时候不注明的话，nocache是默认值。

 

7.更多参考

有关闪回特性请参考

        Oracle 闪回特性(FLASHBACK DATABASE)

Oracle 闪回特性(FLASHBACK DROP & RECYCLEBIN)

Oracle 闪回特性(Flashback Query、Flashback Table)

Oracle 闪回特性(Flashback Version、Flashback Transaction)

 

有关基于用户管理的备份和备份恢复的概念请参考：

        Oracle 冷备份

        Oracle 热备份

        Oracle 备份恢复概念

        Oracle 实例恢复

        Oracle 基于用户管理恢复的处理(详细描述了介质恢复及其处理)

       

    有关RMAN的恢复与管理请参考：

        RMAN 概述及其体系结构

        RMAN 配置、监控与管理

        RMAN 备份详解

        RMAN 还原与恢复

       

    有关Oracle体系结构请参考：

        Oracle 实例和Oracle数据库(Oracle体系结构)

        Oracle 表空间与数据文件

        Oracle 密码文件

        Oracle 参数文件

Oracle 数据库实例启动关闭过程

        Oracle 联机重做日志文件(ONLINE LOG FILE)

        Oracle 控制文件(CONTROLFILE)

        Oracle 归档日志
