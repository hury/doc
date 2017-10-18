spool logs.log
alter session set nls_date_format = 'yyyy-mm-dd hh24:mi:ss';
@RES_DATAELEMENT.sql
@RES_DATAELEMENTCATEGORY.sql
@RES_DATAGROUP.sql
@RES_DATASET.sql
@RES_DATASETCATALOG.sql
@RES_DATASETCONTENT.sql
@RES_DATASTANDARD.sql
commit;
spool off