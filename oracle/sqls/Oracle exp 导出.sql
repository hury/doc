rem 按表名导出数据
exp sa/bsoft@dbcenter tables=yk_ypcd file=yk_ypcd.dmp log=yk_ypcd.log  compress=n
pause

rem 按表名+查询条件导出数据
exp sa/bsoft@dbcenter tables=yk_ypcd file=yk_ypcd.dmp log=yk_ypcd.log  compress=n query="'where mpiid in(select mpiid from test_mpi)'"
pause

rem 按表名导出数据
exp 用户名/密码@数据库名称 tables=表名 file=表名.dmp log=表名.log  compress=n
pause

rem 按表名+查询条件导出数据
exp 用户名/密码@数据库名称 tables=表名 file=表名.dmp log=表名.log  compress=n query="'where id in(123)'"
pause

rem 批量导出单表
select 
'exp pfuser/bsoft@hmp tables='|| table_name ||' file='|| table_name ||'.dmp log='|| table_name ||'.log compress=n' as sqls
from user_tables a
order by num_rows desc 

rem 数据导入
imp ssdev/bsoft@ssdev file=data.dmp tables=(RES_DATASTANDARD,RES_DATASETCATALOG,RES_DATAELEMENTCATEGORY,RES_DATAGROUP,RES_DATASET) ignore=y
pause

