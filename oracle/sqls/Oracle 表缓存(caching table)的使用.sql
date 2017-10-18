Oracle ����(caching table)��ʹ�� 

�ο���http://blog.csdn.net/leshami/article/details/6226767

--************************************

-- Oracle ����(caching table)��ʹ��

--************************************

 

1.ʹ��caching table ��ԭ��

        ��ͨ��������£�Ӧ�ó��������cache�е����ݿ齫����LRU�㷨�����д���Ȼ������С��ķ��ʣ���ʹ��ȫ��ɨ��ʱ����ñ�

    �еĿ�����LRU�б��������ʹ��β����(LRU��)����˺ܿ�ͱ���̭���֡�Ȼ��ʹ�û��ڳɱ��Ż��ķ���������С����в�ѯ�Լ���

    ��ͳ����Ϣ������������ߵ���ȫ��ɨ�裬����Ʊ����һ�����Σ����ñ������Ҫ�ٴη��ʣ���ÿ��ʹ����ȫ��ɨ�裬���ö���ܿ�

    ����̭���֣������Ҫ�ٴζ��뵽buffer cache�������˴�����I/O��

           

2.���������ķ���

    ��Ʊ�Ϊcaching table ����ʹ�Ըñ�ʹ��ȫ�����ʱ����ñ����Ŀ���Ȼ��������LRU�б�������ʹ�õ�β��(MRU��)

    ��Ҫ���ȵ�ʹ��caching table��������������½�

    ͨ����caching table �����keep buffer pool��ȱʡ������»������default buffer pool��

   

3.����cache������pin �Ĳ���

    ���ھ���cache���ԵĶ��󣬲����ǽ��ö���pin��cache����Ǿ����ܵ��ӳٸö���פ��cache��ʱ��

    ������pin�������ǽ��ö���פ���ڴ�

   

4.���cache table �ķ���

    ���������ʱ��ʹ��cache�Ӿ�

    �޸ı����ʱ��ʹ��cache�Ӿ�

    ʹ��cache ��ʾ

   

    ���������ʱʹ��cache�������������

        create table tb_test

        (id number

         ,name varchar2(20)

         ,sex  char(1)

         ,age  number

         ,score number)

         tablespace users

         storage(initial 50k next 50k pctincrease 0)

         cache;    --ָ��cache�Ӿ�

 

     ʹ��alter table �޸��Ѿ����ڵı�

        alter table scott.emp cache;

       

     ����ʹ��nocache���޸Ķ���ʹ�䲻�߱�cache����

        alter table soctt.emp nocache

       

     ʹ��hint��ʾ����ʵ��cache

        select /*+ cache*/ empno,ename from scott.emp;

   

5.ʹ��������ʾcaching table����

 

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

   

        �������ʾ���п��Կ�������tb1ÿ�ζ���ʹ����ͬ�������������tb2һ����load��buffer cache�У�ʼ�մ���LRU��MRU�ˣ������ܵ�

    ������buffer cache��С�����û���buffer cache֮�⡣

        ע�ⲻͬ����ʾ���������������죬���˵���ʾ��������;

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

         

6.ע��cache table��keep buffer pool����ͬ

    ���ߵ�Ŀ�Ķ��Ǿ����ܽ����ȵĶ������ڵ�buffer pool�������ܵı���aged out��

    cache table�ǽ��������ڵ�default buffer cache��

    ��ʹ��buffer_pool keep�Ӿ��ǽ��������ڵ�keep buffer pool��

    ��buffer_pool��cacheͬʱָ��ʱ��keep��cache������Ȩ��buffer_pool����ָ������ʹ�û���أ���cache/nocacheָ���洢��

    ��ʽ(LRU��MRU��)������ʱ��ע���Ļ���nocache��Ĭ��ֵ��

 

7.����ο�

�й�����������ο�

        Oracle ��������(FLASHBACK DATABASE)

Oracle ��������(FLASHBACK DROP & RECYCLEBIN)

Oracle ��������(Flashback Query��Flashback Table)

Oracle ��������(Flashback Version��Flashback Transaction)

 

�йػ����û�����ı��ݺͱ��ݻָ��ĸ�����ο���

        Oracle �䱸��

        Oracle �ȱ���

        Oracle ���ݻָ�����

        Oracle ʵ���ָ�

        Oracle �����û�����ָ��Ĵ���(��ϸ�����˽��ʻָ����䴦��)

       

    �й�RMAN�Ļָ��������ο���

        RMAN ����������ϵ�ṹ

        RMAN ���á���������

        RMAN �������

        RMAN ��ԭ��ָ�

       

    �й�Oracle��ϵ�ṹ��ο���

        Oracle ʵ����Oracle���ݿ�(Oracle��ϵ�ṹ)

        Oracle ��ռ��������ļ�

        Oracle �����ļ�

        Oracle �����ļ�

Oracle ���ݿ�ʵ�������رչ���

        Oracle ����������־�ļ�(ONLINE LOG FILE)

        Oracle �����ļ�(CONTROLFILE)

        Oracle �鵵��־
