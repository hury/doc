/*
2016-5-12 17:34:49 @hury
数据闪回
*/

-- 闪回表
FLASHBACK TABLE TMP_MZXX TO BEFORE DROP;

-- 查看回收站
select * from user_recyclebin;

-- 清空回收站
purge recyclebin;
