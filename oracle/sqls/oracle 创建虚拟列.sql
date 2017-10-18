-- oracle ¥¥Ω®–Èƒ‚¡–
create table t1(
id int, 
name varchar(20),
salary number(18,2)
);
select * from t1;

alter table t1 add  (total_salary as (salary *1.1) virtual);
select * from user_tab_cols where table_name = 'T1';

insert into t1(id,name, salary) values(1,'hury',10);
insert into t1(id,name, salary) values(2,'hury2',100);
insert into t1(id,name, salary) values(3,'hury3',10.50);

alter table t1 drop  column total_salary;