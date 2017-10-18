/*Oracle ҵ������ʱ���������*/
CREATE OR REPLACE PROCEDURE "P_ADD_KETTLE" (
  table_name VARCHAR2) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE(table_name);
    --���ʱ�����
    EXECUTE IMMEDIATE 'Alter Table "'|| table_name || '" add KETTLE_LASTMODIFY TIMESTAMP (6) DEFAULT current_timestamp';
    COMMIT;
    --��Ӵ�����
    EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER KL_'|| SUBSTR('KL_' || table_name,4,27) || '
    BEFORE Insert or Update  ON "'|| table_name || '"
    FOR EACH ROW
    DECLARE
      -- local variables here
    BEGIN
      :NEW.KETTLE_LASTMODIFY := current_timestamp;
    END;';
    COMMIT;
  DBMS_OUTPUT.PUT_LINE('PROCESS OK...');

END p_add_kettle;
