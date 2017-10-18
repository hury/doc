/*
oracle行转列
listagg(column,'分隔符') within group (order by column) over(partition by column)
*/
select a.cfsb, listagg(c.ypmc, ',') within group(order by c.ypmc) as ypmc
  FROM ms_cf01 a, MS_CF02 c
 where a.cfsb = c.cfsb
   and a.kettle_code = c.kettle_code
   and a.kettle_code = 'azsqwsfwzx'
   and a.brid = 6894
 group by a.cfsb
;

select a.cfsb, wm_concat(c.ypmc) as ypmc
  FROM ms_cf01 a, MS_CF02 c
 where a.cfsb = c.cfsb
   and a.kettle_code = c.kettle_code
   and a.kettle_code = 'azsqwsfwzx'
   and a.brid = 6894
 group by a.cfsb
 
--------------------------------------------------------------------------------------------
/*
在oracle 11g release 2 版本中新增的listagg函数，listagg是一个实现字符串聚合的oracle内建函数;
listagg(column,'分隔符') within group (order by column) over(partition by column)
分隔符可以为空，
order by必选项，可以order by null

(1)select status,  listagg(risk_id, ',') within group (order by risk_id) from rp_risk group by status;
以status分组，将risk_id全部合并显示在一行
(2)与许多的聚合函数类似，listagg通过加上over()子句可以实现分析功能
select risk_id, status, listagg(risk_id, ',') within group (order by risk_id) over(partition by status) from rp_risk;
选出与当前risk_id在同一个部门的所有risk_id并合并字符串
(3)listagg聚合的结果列大小限制在varchar2类型的最大值内（比如4000);
(4)合并字符串也可以用wm_concat(column_name),所有版本的oracle都可以用这个函数
　listagg()是oracle 11g release 2才有；
(5)参考链接
http://xpchild.blog.163.com/blog/static/10180985920108485721969/
*/
