2017-07-25 15:16:59 @hury

����������
ORA-12516��TNS�����������Ҳ�������Э��ջҪ��Ŀ��ô������
���������
�鿴���ݿ���������Ƿ��Ѵﵽ����processes�Ĵ�С��

�������裺

1���鿴processes,sessions��ֵ
select count(1) from v$process;
show parameter processes
select * from v$parameter where name ='processes';

select count(1) from v$session;
show parameter sessions
select * from v$parameter where name = 'sessions';

2���޸�processes��sessionsֵ
alter system set processes=300 scope=spfile;

������Ч��
