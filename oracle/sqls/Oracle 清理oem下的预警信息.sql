Oracle 清理oem下的预警信息

# 问题描述：OEM的HOME页面可以显示ORACLE的报警信息，但报警事件清除后该信息不会自动清除。随着时间的增长，信息量逐渐加大，解决方法是手工予以清除。

解决步骤：

1、  用下面的语句组装生成清除警告信息的脚本
select 'exec em_severity.delete_current_severity(''' || target_guid || ''',''' || metric_guid || ''',''' || key_value || ''');'
  from sysman.mgmt_current_severity

2、以sysman用户login SQLPLUS 后执行上一步生成的脚本（注意是sysman用户，用sys不行）
