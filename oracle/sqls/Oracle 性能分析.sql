-- Oracle性能分析
DROP VIEW V_TOP_DYNAMIC_SQL;
-- 创建视图
CREATE OR REPLACE VIEW V_TOP_DYNAMIC_SQL
AS SELECT USER_NAME,MACHINE,OSUSER,PROGRAM,SID,SERIAL#,EXECUTIONS,OPTIMIZER_COST,SORTS,SQL_TEXT 
FROM (
select o.user_name, s.machine, s.osuser, s.program, o.sid,s.serial#, q.EXECUTIONS, q.OPTIMIZER_COST, q.sorts, q.sql_text
from v$open_cursor o, v$sql q, v$session s
where q.hash_value=o.hash_value 
and o.sid=s.sid
and o.user_name = USER
and q.optimizer_cost>0
order by q.optimizer_cost desc,q.EXECUTIONS DESC, q.sorts DESC 
) a
;


-- 查询
select * from (
SELECT * FROM V_TOP_DYNAMIC_SQL a
ORDER BY a.optimizer_cost desc, a.EXECUTIONS DESC, a.sorts DESC 
) a WHERE rownum<=100
;
