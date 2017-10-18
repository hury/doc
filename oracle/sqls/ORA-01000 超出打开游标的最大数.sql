/*
2016-7-18 16:40:46 @hury
ORA-01000: �������α������� ����ķ����ͽ��
֢״:ϵͳ������һ��ʱ�䱨��java.sql.SQLException: ORA-01000: �������α�������
*/

/*step 1:�鿴���ݿ⵱ǰ���α�������slqplus:*/
show parameter open_cursors;

/*step 2:�鿴�α�ʹ�������
�˴���user_name='user'��,user����ռ�����ݿ���Դ�����ݿ��û���.
*/
select o.sid, osuser, machine, count(*) num_curs
from v$open_cursor o, v$session s
where user_name = 'SA' and o.sid=s.sid
group by o.sid, osuser, machine
order by  num_curs desc;


/*step 3:�鿴�α�ִ�е�sql�����*/
select o.sid,q.sql_text
from v$open_cursor o, v$sql q
where q.hash_value=o.hash_value and o.sid = 123;

/*�鿴�û��µ�sql���*/
select o.sid,q.sql_text
from v$open_cursor o, v$sql q
where q.hash_value=o.hash_value 
and o.user_name = 'SA';

/*step 4:�����α�ռ����������������ݿ�ĳ�������Դ�ͷ����Ƿ�����,��������ͷ���Դû�����⣬��Ӵ��α�����*/
alter system set open_cursors=2000 scope=both;
   
/*����:��java������,ִ��conn.createStatement()��conn.prepareStatement()��ʱ��ʵ���϶����൱�������ݿ��д���һ��cursor��
�����ǣ�������createStatement��prepareStatement����һ��ѭ������Ļ����ͻ�ǳ����׳���������⡣��Ϊ�α�һֱ�ڲ�ͣ�Ĵ򿪣�����û�йرա�
һ����˵��������дJava�����ʱ��createStatement��prepareStatement��Ӧ��Ҫ����ѭ�����棬����ʹ������ЩStatment�󣬼�ʱ�رա�
�������ִ����һ��executeQuery��executeUpdate��֮���������Ҫʹ�ý������ResultSet�������ݣ������Ͻ�Statment�رգ�����close()������
*/

select count(1) from v$session ;
select count(1) from v$open_cursor;
select count(1) from v$process;
