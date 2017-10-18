@echo off
set oracle_sid=dbcenter
sqlplus / as sysdba < cmds.sql

@echo on
echo %date% %time% >>log.txt
