/*
sql去除连续重复值
描述：有如下表
-----------------
id  name  muser
1   n1    u1
2   n1    u2
3   n1    u3
4   n2    u4
5   n1    u5
-----------------
要求：去除表中连续重复的 name 值，输出如下结果：
-----------------
id  name  muser
1   n1    u1
4   n2    u4
5   n1    u5
-----------------
*/
with x as(
select 1 as id, 'n1' as name, 'u1' as muser from dual union all 
select 2 as id, 'n1' as name, 'u2' as muser from dual union all 
select 3 as id, 'n1' as name, 'u2' as muser from dual union all 
select 4 as id, 'n2' as name, 'u3' as muser from dual union all 
select 5 as id, 'n1' as name, 'u4' as muser from dual 
)
select * from x c where not exists(
select b.id from x a, x b
where b.id = a.id+1
and b.name = a.name
and c.id = b.id
)
order by c.id
