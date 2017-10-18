/*
2016-7-18 16:40:46 @hury
ORA-01000: 超出打开游标的最大数 问题的分析和解决
症状:系统运行了一段时间报错：java.sql.SQLException: ORA-01000: 超出打开游标的最大数
*/

/*step 1:查看数据库当前的游标数配置slqplus:*/
show parameter open_cursors;

/*step 2:查看游标使用情况：
此处的user_name='user'中,user代表占用数据库资源的数据库用户名.
*/
select o.sid, osuser, machine, count(*) num_curs
from v$open_cursor o, v$session s
where user_name = 'SA' and o.sid=s.sid
group by o.sid, osuser, machine
order by  num_curs desc;


/*step 3:查看游标执行的sql情况：*/
select o.sid,q.sql_text
from v$open_cursor o, v$sql q
where q.hash_value=o.hash_value and o.sid = 123;

/*查看用户下的sql语句*/
select o.sid,q.sql_text
from v$open_cursor o, v$sql q
where q.hash_value=o.hash_value 
and o.user_name = 'SA';

/*step 4:根据游标占用情况分析访问数据库的程序在资源释放上是否正常,如果程序释放资源没有问题，则加大游标数。*/
alter system set open_cursors=2000 scope=both;
   
/*补充:在java代码中,执行conn.createStatement()和conn.prepareStatement()的时候，实际上都是相当与在数据库中打开了一个cursor。
尤其是，如果你的createStatement和prepareStatement是在一个循环里面的话，就会非常容易出现这个问题。因为游标一直在不停的打开，而且没有关闭。
一般来说，我们在写Java代码的时候，createStatement和prepareStatement都应该要放在循环外面，而且使用了这些Statment后，及时关闭。
最好是在执行了一次executeQuery、executeUpdate等之后，如果不需要使用结果集（ResultSet）的数据，就马上将Statment关闭，调用close()方法。
*/

select count(1) from v$session ;
select count(1) from v$open_cursor;
select count(1) from v$process;
