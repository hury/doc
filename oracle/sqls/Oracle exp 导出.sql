rem ��������������
exp sa/bsoft@dbcenter tables=yk_ypcd file=yk_ypcd.dmp log=yk_ypcd.log  compress=n
pause

rem ������+��ѯ������������
exp sa/bsoft@dbcenter tables=yk_ypcd file=yk_ypcd.dmp log=yk_ypcd.log  compress=n query="'where mpiid in(select mpiid from test_mpi)'"
pause

rem ��������������
exp �û���/����@���ݿ����� tables=���� file=����.dmp log=����.log  compress=n
pause

rem ������+��ѯ������������
exp �û���/����@���ݿ����� tables=���� file=����.dmp log=����.log  compress=n query="'where id in(123)'"
pause

rem ������������
select 
'exp pfuser/bsoft@hmp tables='|| table_name ||' file='|| table_name ||'.dmp log='|| table_name ||'.log compress=n' as sqls
from user_tables a
order by num_rows desc 

rem ���ݵ���
imp ssdev/bsoft@ssdev file=data.dmp tables=(RES_DATASTANDARD,RES_DATASETCATALOG,RES_DATAELEMENTCATEGORY,RES_DATAGROUP,RES_DATASET) ignore=y
pause

