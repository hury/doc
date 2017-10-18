--2014-02-13 09:29:17 @hury
--字典项检测

--===================================================
--创建一个　　type　　，如果为了使split函数具有通用性，请将其size 设大些。
create type type_split as table of varchar2(255); 

--===================================================
/*
2014-02-13 09:35:22 @hury
用途：将字符串分隔为一列数据
输入：1,12,123
返回：
1
12
123

@param p_list 字符串
@param p_sep 分隔符

调用方式：
select * from table(f_split('1,12,123',','));
*/
create or replace
function f_split
  (
    p_list varchar2,
    p_sep  varchar2 := ',' )
  return type_split pipelined
is
  l_idx pls_integer;
  v_list varchar2(50) := p_list;
begin
  loop
    l_idx   := instr(v_list,p_sep);
    if l_idx > 0 then
      pipe row(substr(v_list,1,l_idx-1));
      v_list := substr(v_list,l_idx +length(p_sep));
    else
      pipe row(v_list);
      exit;
    end if;
  end loop;
  return;
end f_split;
--===================================================
/*

2014-02-13 09:29:17 @hury
字典项检测

@param col 列名
@param item 字典项

检测字典类型的字段中是否包含某个指定的值
例如字段a中的值可能为：1,12,123，判断其中是否包含1
如何包含字典项，返回1，否则返回0

SELECT CY_SPECIAL_GROUP,phrid FROM EHR_HEALTHRECORD where length(CY_SPECIAL_GROUP)>1 ;

SELECT CY_SPECIAL_GROUP,phrid 
,f_exists_dic_item(CY_SPECIAL_GROUP,'2') cz
FROM EHR_HEALTHRECORD WHERE phrid = '1101053800000702';

*/
CREATE or replace FUNCTION f_exists_dic_item(col in VARCHAR, item in VARCHAR)
RETURN VARCHAR
is sReturn VARCHAR(255);  
BEGIN 
    SELECT column_value into sReturn FROM TABLE(f_split(col)) WHERE column_value = item;
    IF sReturn IS NULL THEN 
    	RETURN '0';
    ELSE 
    	RETURN '1';
    END IF;
    
    EXCEPTION
    WHEN OTHERS THEN
    RETURN '0';
END
;
--===================================================