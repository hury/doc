--查看已经锁定锁表进程sql语句1：
select sess.sid,
    sess.serial#,
    lo.oracle_username,
    lo.os_user_name,
    ao.object_name,
    lo.locked_mode
from v$locked_object lo,
    dba_objects ao,
    v$session sess
where ao.object_id = lo.object_id and lo.session_id = sess.sid;

--查看锁表进程sql语句2：
select * from v$session t1, v$locked_object t2 where t1.sid = t2.session_id;

--杀掉锁表进程：
--如有记录則表示有lock，记录下sid和serial# ，將记录的id替換下面的738,1429，即可解除lock
alter system kill session '366,8152'; 

------------------------------------------------------------
Oracle里锁有以下几种模式: locked_mode
0：none
1：null 空
2：Row-S 行共享(RS)：共享表锁，sub share 
3：Row-X 行独占(RX)：用于行的修改，sub exclusive 
4：Share 共享锁(S)：阻止其他DML操作，share
5：S/Row-X 共享行独占(SRX)：阻止其他事务操作，share/sub exclusive 
6：exclusive 独占(X)：独立访问使用，exclusive

------------------------------------------------------------
-- 1. 查看被锁的表
select p.spid, a.serial#, c.object_name, b.session_id, b.oracle_username,
       b.os_user_name
  from v$process p, v$session a, v$locked_object b, all_objects c
 where p.addr = a.paddr and a.process = b.process
       and c.object_id = b.object_id
       
-- 查看表锁
select   s.sid session_id, s.username
, decode(lmode, 0, ' None ', 1, ' Null ', 2, ' Row-S (SS) ', 3, ' Row-X (SX) ', 4, ' Share ', 5, ' S/Row-X (SSX) ', 6, ' Exclusive ', to_char(lmode)) mode_held
, decode(request, 0, ' None ', 1, ' Null ', 2, ' Row-S (SS) ', 3, ' Row-X (SX) ', 4, ' Share ', 5, ' S/Row-X (SSX) ', 6, ' Exclusive ', to_char(request)) mode_requested
, o.owner || ' . ' || o. object_name || ' ( ' || o.object_type || ' ) ' 
, s.type lock_type, l.id1 lock_id1, l.id2 lock_id2 
from  v$lock l, sys.dba_objects o, v$session s 
where  l.sid  =  s.sid  and   l.id1  =  o. object_id 

-- 2. 查看是哪个进程锁的 
select sid, serial#, username, osuser from v$session  where osuser = 'hury'

-- 3. 杀掉这个进程  
alter system kill session 331;

-- 查看当前session中正在执行的sql
select substr(s.username, 1, 18) username, s.sid, s.serial#, s.machine, y.sql_text
  from v$session s, v$process p, v$transaction t, v$rollstat r, v$rollname n, v$sql y
 where s.paddr = p.addr
   and s.taddr = t.addr(+)
   and t.xidusn = r.usn(+)
   and r.usn = n.usn(+)
   and s.username is not null
   and s.sql_address = y.address
--and s.sid=56
 order by s.sid, s.serial#, s.username, s.status
;
