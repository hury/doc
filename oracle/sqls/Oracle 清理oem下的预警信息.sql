Oracle ����oem�µ�Ԥ����Ϣ

# ����������OEM��HOMEҳ�������ʾORACLE�ı�����Ϣ���������¼���������Ϣ�����Զ����������ʱ�����������Ϣ���𽥼Ӵ󣬽���������ֹ����������

������裺

1��  ������������װ�������������Ϣ�Ľű�
select 'exec em_severity.delete_current_severity(''' || target_guid || ''',''' || metric_guid || ''',''' || key_value || ''');'
  from sysman.mgmt_current_severity

2����sysman�û�login SQLPLUS ��ִ����һ�����ɵĽű���ע����sysman�û�����sys���У�
