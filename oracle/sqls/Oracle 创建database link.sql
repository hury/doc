-- 2016-7-13 11:19:04 @hury
-- Oracle ´´½¨database link
create database link dbcenter
connect to sa
identified by bsoft
using '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=172.16.1.120)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=dbcenter)))';

select * from ms_brda@dbcenter;
where rownum<10;

drop database link dbcenter;
