--2014-02-13 09:29:17 @hury
--�ֵ�����

--===================================================
--����һ������type���������Ϊ��ʹsplit��������ͨ���ԣ��뽫��size ���Щ��
create type type_split as table of varchar2(255); 

--===================================================
/*
2014-02-13 09:35:22 @hury
��;�����ַ����ָ�Ϊһ������
���룺1,12,123
���أ�
1
12
123

@param p_list �ַ���
@param p_sep �ָ���

���÷�ʽ��
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
�ֵ�����

@param col ����
@param item �ֵ���

����ֵ����͵��ֶ����Ƿ����ĳ��ָ����ֵ
�����ֶ�a�е�ֵ����Ϊ��1,12,123���ж������Ƿ����1
��ΰ����ֵ������1�����򷵻�0

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