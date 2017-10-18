-- Oracle批量生成表空间创建语句
with x1 as (/*年份*/
     select cast(2010 + rownum as varchar(4)) as y from dual connect by level<=6
), x2 as (/*季度*/
   select '01' as q from dual union all 
   select '02' as q from dual union all 
   select '03' as q from dual union all 
   select '04' as q from dual 
) 
select * from (
select 'create tablespace ts_'|| x1.y ||'_'|| x2.q ||' logging datafile ''h:\database\dbcenter\ts_'|| x1.y ||'_'|| x2.q ||'.dbf'' size 10m autoextend on next 10m maxsize 32767m extent management local;' as sql
from x1, x2 order by x1.y, x2.q)
union all 
select 'create tablespace ts_max logging datafile ''h:\database\dbcenter\ts_max.dbf'' size 10m autoextend on next 10m maxsize 32767m extent management local;' as sql
from dual;


-- 表分区创建语句模版
with x1 as (/*年份*/
     select cast(2010 + rownum as varchar(4)) as y
     from dual connect by level<=6
), x2 as (/*季度*/
   select '01' as q, '04' as q2 from dual union all 
   select '02' as q, '07' as q2 from dual union all 
   select '03' as q, '10' as q2 from dual union all 
   select '04' as q, '01' as q2 from dual 
) 
select * from (
select 'PARTITION ts_'|| x1.y ||'_'|| x2.q ||' VALUES less than (to_date(''' 
       || cast(case when x2.q2='01' then cast(x1.y as number(4))+1 else cast(x1.y as number(4)) end as varchar(4)) 
       ||'-'|| x2.q2 ||'-01'',''yyyy-mm-dd'')) tablespace ts_'|| x1.y ||'_'|| x2.q ||', ' as sql
from x1, x2
order by x1.y, x2.q)
union all 
select 'PARTITION ts_max VALUES less than (maxvalue) tablespace ts_max' from dual
;
