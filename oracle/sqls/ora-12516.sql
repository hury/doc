2017-07-25 15:16:59 @hury

错误描述：
ORA-12516：TNS：监听程序找不到符合协议栈要求的可用处理程序；
需求分析：
查看数据库进程数，是否已达到参数processes的大小；

操作步骤：

1、查看processes,sessions的值
select count(1) from v$process;
show parameter processes
select * from v$parameter where name ='processes';

select count(1) from v$session;
show parameter sessions
select * from v$parameter where name = 'sessions';

2、修改processes和sessions值
alter system set processes=300 scope=spfile;

重启生效；
