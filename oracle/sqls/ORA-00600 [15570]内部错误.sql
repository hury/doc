2017-08-17 13:28:12 @hury

ORA-00600:[15570]内部错误一例

一套Linux上的10.2.0.1系统出现ORA-00600:[15570]内部错误，日志如下:

Sat Jun 5 11:33:17 2010
Memory Notification: Library Cache Object loaded into SGA
Heap size 2190K exceeds notification threshold (2048K)
KGL object name :XDB.XDbD/PLZ01TcHgNAgAIIegtw==
Sat Jun 5 14:57:25 2010
Thread 1 advanced to log sequence 16540
Current log# 3 seq# 16540 mem# 0: /ora_data/mantas/redo03.log
Sat Jun 5 14:58:37 2010
Errors in file /opt/oracle/admin/mantas/udump/mantas_ora_10803.trc:
ORA-00600: internal error code, arguments: [15570], [], [], [], [], [], [], []
Sat Jun 5 14:58:37 2010
Errors in file /opt/oracle/admin/mantas/udump/mantas_ora_10903.trc:
ORA-00600: internal error code, arguments: [15570], [], [], [], [], [], [], []
Sat Jun 5 14:58:39 2010
Errors in file /opt/oracle/admin/mantas/udump/mantas_ora_10801.trc:
ORA-00600: internal error code, arguments: [15570], [], [], [], [], [], [], []

##23393_trc.rtf##

/opt/oracle/admin/mantas/udump/mantas_ora_23393.trc
Oracle Database 10g Enterprise Edition Release 10.2.0.1.0 - Production
With the Partitioning, OLAP and Data Mining options
ORACLE_HOME = /opt/oracle
System name: Linux
Node name: mandbdev.ssfcu.inet
Release: 2.6.9-55.ELsmp
Version: #1 SMP Fri Apr 20 17:03:35 EDT 2007
Machine: i686
Instance name: mantas
Redo thread mounted by this instance: 1
Oracle process number: 32
Unix process pid: 23393, image: oraclemantas@mandbdev.ssfcu.inet

*** SERVICE NAME:(mantas.ssfcu.inet) 2010-06-05 09:17:10.438
*** SESSION ID:(540.115) 2010-06-05 09:17:10.438
*** 2010-06-05 09:17:10.438
ksedmp: internal or fatal error
ORA-00600: internal error code, arguments: [15570], [], [], [], [], [], [], []
Current SQL statement for this session:
SELECT t94.ACCT_INTRL_ID, t94.FO_TRXN_SEQ_ID, t94.TRXN_EXCTN_DT, t94.CASH_TRXN_ACTVY_RISK_NB, t94.CUST_INTRL_ID, t94.CUST_EFCTV_RISK_NB, t94.TRXN_BASE_AM, t94.D_HR_TRXN_AM, t94.D_LRF_TRXN_AM FROM (-- Only one part of UNION ALL will be executed
-- threshold 'N' define which of them
-- 'N' is parameter that indicates what account are included for customer focus to monitor :
-- Y - cover only accounts for which a customer plays a primary role
-- N - cover account over which a customer has a discretion
-- PR-39791 singhan dated 03/23/09
-- Replaced (BUS_DAY_AGE = 0 and bus_day_fl='Y' ) with Clndr_Day_Age = 0
-- Included "Exclude Cash Transaction Report Exemption Accounts" filter using coalesce (a.CASH_RPT_EXMPT_FL, ' ')<>'Y'
-- Date: 1st Feb 2010 : PR 42362 : Exclude cancelled and canceling transactions
-- tr.CXL_PAIR_TRXN_INTRL_ID is null
SELECT
t.TRXN_BASE_AM
, c.CUST_INTRL_ID
, t.CASH_TRXN_ACTVY_RISK_NB
, t.FO_TRXN_SEQ_ID
, t.TRXN_EXCTN_DT
, a.ACCT_INTRL_ID
, CASE WHEN t.TRXN_BASE_AM-TRUNC(t.TRXN_BASE_AM,-4)=0 THEN t.TRXN_BASE_AM
WHEN t.TRXN_ACTVY_AM-TRUNC(t.TRXN_ACTVY_AM,-4)=0 THEN t.TRXN_BASE_AM
ELSE 0
END as d_LRF_TRXN_AM
, c.CUST_EFCTV_RISK_NB
, CASE WHEN t.CASH_TRXN_NTITY_RISK_NB>0 or t.CASH_TRXN_ACTVY_RISK_NB>0 THEN t.TRXN_BASE_AM ELSE 0 END D_HR_TRXN_AM
FROM
BUSINESS.CASH_TRXN t
inner join BUSINESS.ACCT a on a.ACCT_INTRL_ID = t.ACCT_INTRL_ID
inner join BUSINESS.CUST c on c.CUST_INTRL_ID=a.PRMRY_CUST_INTRL_ID
WHERE
-- Exclude cancelled and canceling transactions
-- PR 42362
t.CXL_PAIR_TRXN_INTRL_ID is null
--Exclude Exempted Customers
and c.CUST_EFCTV_RISK_NB <> -2
-- Cover customers either from all jurisdiction or from Incl_Jurisdictions_Lst only
and ('Y'='Y' or c.JRSDCN_CD in ('BUS'))
-- Include Retail Customer Accounts Only
and a.MANTAS_ACCT_HOLDR_TYPE_CD='CR'
-- Cover only specific accounts
and a.MANTAS_ACCT_BUS_TYPE_CD in ('RBK', 'RBR')
--
and t.MANTAS_TRXN_PRDCT_CD in ('CURRENCY')
and t.MANTAS_TRXN_PURP_CD = 'GENERAL'
-- Cover either all transaction or only form the Incl_Trans_Src_Lst
and ('Y'='Y' or t.SRC_SYS_CD in ('Inactive'))
-- PR-39791 start
-- Exclude Cash Transaction Report Exemption Accounts
and coalesce (a.CASH_RPT_EXMPT_FL, ' ')<>'Y'
and t.TRXN_EXCTN_DT <= (select k0.clndr_dt from MANTAS.KDD_CAL k0 where k0.Clndr_Day_Age = 0 and k0.clndr_nm = 'SYSCAL') and t.TRXN_EXCTN_DT > (select k1.clndr_dt from MANTAS.KDD_CAL k1 where k1.Clndr_Day_Age = 30 and k1.clndr_nm = 'SYSCAL')
and t.DATA_DUMP_DT <= (select k0.clndr_dt from MANTAS.KDD_CAL k0 where k0.Clndr_Day_Age = 0 and k0.clndr_nm = 'SYSCAL') and t.DATA_DUMP_DT > (select k1.clndr_dt from MANTAS.KDD_CAL k1 where k1.Clndr_Day_Age = 30 and k1.clndr_nm = 'SYSCAL')
-- PR-39791 start
-- Parameter that indicates what account are included for customer focus to monitor :
-- Y - cover only accounts for which a customer plays a primary role
-- N - cover account over which a customer has a discretion
and 'N' = 'Y'
-----------------------------------------
UNION ALL
------------------------------------------
SELECT
t.TRXN_BASE_AM
, c.CUST_INTRL_ID
, t.CASH_TRXN_ACTVY_RISK_NB
, t.FO_TRXN_SEQ_ID
, t.TRXN_EXCTN_DT
, a.ACCT_INTRL_ID
, CASE WHEN t.TRXN_BASE_AM-TRUNC(t.TRXN_BASE_AM,-4)=0 THEN t.TRXN_BASE_AM
WHEN t.TRXN_ACTVY_AM-TRUNC(t.TRXN_ACTVY_AM,-4)=0 THEN t.TRXN_BASE_AM
ELSE 0
END as d_LRF_TRXN_AM
, c.CUST_EFCTV_RISK_NB
, CASE WHEN t.CASH_TRXN_NTITY_RISK_NB>0 or t.CASH_TRXN_ACTVY_RISK_NB>0 THEN t.TRXN_BASE_AM ELSE 0 END d_HR_TRXN_AM
FROM
BUSINESS.CASH_TRXN t
inner join BUSINESS.ACCT a on t.acct_intrl_id = a.acct_intrl_id
inner join BUSINESS.CUST_ACCT ca on a.acct_intrl_id = ca.acct_intrl_id
inner join BUSINESS.CUST c on ca.CUST_INTRL_ID = c.CUST_INTRL_ID
inner join BUSINESS.CUST_ACCT_ROLE car on ca.cust_acct_role_cd = car.cust_acct_role_cd
WHERE
-- Exclude cancelled and canceling transactions
-- PR 42362
t.CXL_PAIR_TRXN_INTRL_ID is null
--Exclude Exempted Customers
and c.CUST_EFCTV_RISK_NB <> -2
-- Cover customers either from all jurisdiction or from Incl_Jurisdictions_Lst only
and ('Y'='Y' or c.JRSDCN_CD in ('BUS'))
-- Include Retail Customer Accounts Only
and a.MANTAS_ACCT_HOLDR_TYPE_CD='CR'
-- Cover only specific accounts
and a.MANTAS_ACCT_BUS_TYPE_CD in ('RBK', 'RBR')
--
and t.MANTAS_TRXN_PRDCT_CD in ('CURRENCY')
and t.MANTAS_TRXN_PURP_CD = 'GENERAL'
-- Cover either all transaction or only form the Incl_Trans_Src_Lst
and ('Y'='Y' or t.SRC_SYS_CD in ('Inactive'))
-- PR-39791 start
-- Exclude Cash Transaction Report Exemption Accounts
and coalesce (a.CASH_RPT_EXMPT_FL, ' ')<>'Y'
and t.TRXN_EXCTN_DT <= (select k0.clndr_dt from MANTAS.KDD_CAL k0 where k0.Clndr_Day_Age = 0 and k0.clndr_nm = 'SYSCAL') and t.TRXN_EXCTN_DT > (select k1.clndr_dt from MANTAS.KDD_CAL k1 where k1.Clndr_Day_Age = 30 and k1.clndr_nm = 'SYSCAL')
and t.DATA_DUMP_DT <= (select k0.clndr_dt from MANTAS.KDD_CAL k0 where k0.Clndr_Day_Age = 0 and k0.clndr_nm = 'SYSCAL') and t.DATA_DUMP_DT > (select k1.clndr_dt from MANTAS.KDD_CAL k1 where k1.Clndr_Day_Age = 30 and k1.clndr_nm = 'SYSCAL')
-- PR-39791 end
-- Parameter that indicates what account are included for customer focus to monitor :
-- Y - cover only accounts for which a customer plays a primary role
-- N - cover account over which a customer has a discretion
and 'N' = 'N'
-- Account Customer Role will be viewed as disretionary
and (car.trdng_auth_fl = 'Y' or car.wdrwl_auth_fl = 'Y' or car.poa_fl = 'Y')
) t94, RULE_MATCHER_TEMP910701_0 t106 WHERE t94.CUST_INTRL_ID = t106.FOCAL_ENTITY_ID ORDER BY t94.FO_TRXN_SEQ_ID ASC

CALL STACK
--------------

ksedst <- ksedmp <- ksfdmp <- kgeriv <- kgeasi
<- qerpxFetch <- opifch2 <- kpoal8 <- opiodr <- ttcpip
<- opitsk <- opiino <- opiodr <- opidrv <- sou2o
<- opimai_real <- main <- libc_start_main PROCESS STATE ------------------- SO: 0x3ed2a160, type: 4, owner: 0x3f7e28f4, flag: INIT/-/-/0x00 (session) sid: 540 trans: (nil), creator: 0x3f7e28f4, flag: (8000041) USR/- BSY/-/-/-/-/- DID: 0001-0020-00000265, short-term DID: 0000-0000-00000000 txn branch: (nil) oct: 3, prv: 0, sql: 0x36e5e194, psql: 0x36c493d8, user: 65/KDD_ALG O/S info: user: mantas, term: , ospid: 26740, machine: manappdev program: mantas@manappdev (TNS V1-V3) application name: mantas@manappdev (TNS V1-V3), hash value=0 last wait for 'PX Deq: Execute Reply' blocking sess=0x(nil) seq=1052 wait_time=150 seconds since wait started=0 sleeptime/senderid=c8, passes=1, =0 Dumping Session Wait History for 'PX Deq: Execute Reply' count=1 wait_time=150 sleeptime/senderid=c8, passes=1, =0 for 'PX Deq: Execute Reply' count=1 wait_time=21 sleeptime/senderid=c8, passes=2, =0 for 'PX Deq: Execute Reply' count=1 wait_time=2 sleeptime/senderid=c8, passes=1, =0 for 'PX Deq: Execute Reply' count=1 wait_time=3 sleeptime/senderid=a, passes=1, =0 for 'PX Deq: Execute Reply' count=1 wait_time=165 sleeptime/senderid=c8, passes=1, =0 for 'PX Deq Credit: send blkd' count=1 wait_time=1918048 sleeptime/senderid=10010002, passes=1, qref=0 for 'db file sequential read' count=1 wait_time=4045 file#=1e, block#=5681, blocks=1 for 'db file sequential read' count=1 wait_time=13290 file#=1e, block#=7a99, blocks=1 for 'db file sequential read' count=1 wait_time=5331 file#=1e, block#=c4, blocks=1 for 'PX Deq: Execute Reply' count=1 wait_time=21 sleeptime/senderid=c8, passes=1, =0 temporary object counter: 0 ============ Plan Table ============ ---------------------------------------------------------------------------------+-----------------------------------+-------------------------+---------------+ | Id | Operation | Name | Rows | Bytes | Cost | Time | TQ |IN-OUT|PQ Distrib | Pstart| Pstop | ---------------------------------------------------------------------------------+-----------------------------------+-------------------------+---------------+ | 0 | SELECT STATEMENT | | | | 67 | | | | | | | | 1 | PX COORDINATOR | | | | | | | | | | | | 2 | PX SEND QC (ORDER) | :TQ10004 | 12 | 1884 | 67 | 00:00:01 |:Q1004| P->S |QC (ORDER) | | |
| 3 | SORT ORDER BY | | 12 | 1884 | 67 | 00:00:01 |:Q1004| PCWP | | | |
| 4 | PX RECEIVE | | 12 | 1884 | 66 | 00:00:01 |:Q1004| PCWP | | | |
| 5 | PX SEND RANGE | :TQ10003 | 12 | 1884 | 66 | 00:00:01 |:Q1003| P->P |RANGE | | |
| 6 | BUFFER SORT | | 12 | 1884 | | |:Q1003| PCWP | | | |
| 7 | NESTED LOOPS | | 12 | 1884 | 66 | 00:00:01 |:Q1003| PCWP | | | |
| 8 | BUFFER SORT | | | | | |:Q1003| PCWC | | | |
| 9 | PX RECEIVE | | | | | |:Q1003| PCWP | | | |
| 10 | PX SEND BROADCAST | :TQ10000 | | | | | | S->P |BROADCAST | | |
| 11 | TABLE ACCESS FULL | RULE_MATCHER_TEMP910701_0| 82 | 820 | 3 | 00:00:01 | | | | | |
| 12 | VIEW | | 1 | 147 | | |:Q1003| PCWP | | | |
| 13 | UNION ALL PUSHED PREDICATE | | | | | |:Q1003| PCWP | | | |
| 14 | FILTER | | | | | |:Q1003| PCWC | | | |
| 15 | TABLE ACCESS BY LOCAL INDEX ROWID | CASH_TRXN | 1 | 79 | 3 | 00:00:01 |:Q1003| PCWC | | | |
| 16 | NESTED LOOPS | | 1 | 140 | 7 | 00:00:01 |:Q1003| PCWP | | | |
| 17 | BUFFER SORT | | | | | |:Q1003| PCWC | | | |
| 18 | PX RECEIVE | | | | | |:Q1003| PCWP | | | |
| 19 | PX SEND BROADCAST | :TQ10001 | | | | | | S->P |BROADCAST | | |
| 20 | NESTED LOOPS | | 1 | 61 | 3 | 00:00:01 | | | | | |
| 21 | TABLE ACCESS BY INDEX ROWID | CUST | 1 | 27 | 1 | 00:00:01 | | | | | |
| 22 | INDEX UNIQUE SCAN | PK_CUST | 1 | | 1 | 00:00:01 | | | | | |
| 23 | TABLE ACCESS BY INDEX ROWID | ACCT | 1 | 34 | 2 | 00:00:01 | | | | | |
| 24 | INDEX RANGE SCAN | ACCT_CUST_IDX | 4 | | 1 | 00:00:01 | | | | | |
| 25 | PX PARTITION RANGE ITERATOR | | 1 | | 2 | 00:00:01 |:Q1003| PCWC | | KEY | KEY |
| 26 | INDEX RANGE SCAN | CASH_ACCTID_IDX | 1 | | 2 | 00:00:01 |:Q1003| PCWP | | KEY | KEY |
| 27 | TABLE ACCESS BY INDEX ROWID | KDD_CAL | 1 | 19 | 1 | 00:00:01 |:Q1003| PCWP | | | |
| 28 | INDEX UNIQUE SCAN | AK1_KDD_CAL | 1 | | 1 | 00:00:01 |:Q1003| PCWP | | | |
| 29 | TABLE ACCESS BY INDEX ROWID | KDD_CAL | 1 | 19 | 1 | 00:00:01 | | | | | |
| 30 | INDEX UNIQUE SCAN | AK1_KDD_CAL | 1 | | 1 | 00:00:01 | | | | | |
| 31 | TABLE ACCESS BY INDEX ROWID | KDD_CAL | 1 | 19 | 1 | 00:00:01 | | | | | |
| 32 | INDEX UNIQUE SCAN | AK1_KDD_CAL | 1 | | 1 | 00:00:01 | | | | | |
| 33 | TABLE ACCESS BY INDEX ROWID | KDD_CAL | 1 | 19 | 1 | 00:00:01 | | | | | |
| 34 | INDEX UNIQUE SCAN | AK1_KDD_CAL | 1 | | 1 | 00:00:01 | | | | | |
| 35 | TABLE ACCESS BY LOCAL INDEX ROWID | CASH_TRXN | 1 | 79 | 3 | 00:00:01 |:Q1003| PCWC | | 1 | 1 |
| 36 | NESTED LOOPS | | 1 | 173 | 18 | 00:00:01 |:Q1003| PCWP | | | |
| 37 | BUFFER SORT | | | | | |:Q1003| PCWC | | | |
| 38 | PX RECEIVE | | | | | |:Q1003| PCWP | | | |
| 39 | PX SEND BROADCAST | :TQ10002 | | | | | | S->P |BROADCAST | | |
| 40 | NESTED LOOPS | | 5 | 470 | 5 | 00:00:01 | | | | | |
| 41 | NESTED LOOPS | | 5 | 350 | 4 | 00:00:01 | | | | | |
| 42 | NESTED LOOPS | | 5 | 290 | 2 | 00:00:01 | | | | | |
| 43 | TABLE ACCESS BY INDEX ROWID | CUST | 1 | 27 | 1 | 00:00:01 | | | | | |
| 44 | INDEX UNIQUE SCAN | PK_CUST | 1 | | 1 | 00:00:01 | | | | | |
| 45 | INDEX RANGE SCAN | PK_CUST_ACCT | 5 | 155 | 1 | 00:00:01 | | | | | |
| 46 | TABLE ACCESS BY INDEX ROWID | CUST_ACCT_ROLE | 1 | 12 | 1 | 00:00:01 | | | | | |
| 47 | INDEX UNIQUE SCAN | PK_CUST_ACCT_ROLE | 1 | | 1 | 00:00:01 | | | | | |
| 48 | TABLE ACCESS BY INDEX ROWID | ACCT | 1 | 24 | 1 | 00:00:01 | | | | | |
| 49 | INDEX UNIQUE SCAN | PK_ACCT | 1 | | 1 | 00:00:01 | | | | | |
| 50 | PX PARTITION RANGE ITERATOR | | 1 | | 2 | 00:00:01 |:Q1003| PCWC | | KEY | KEY |
| 51 | INDEX RANGE SCAN | CASH_ACCTID_IDX | 1 | | 2 | 00:00:01 |:Q1003| PCWP | | KEY | KEY |
| 52 | TABLE ACCESS BY INDEX ROWID | KDD_CAL | 1 | 19 | 1 | 00:00:01 |:Q1003| PCWP | | | |
| 53 | INDEX UNIQUE SCAN | AK1_KDD_CAL | 1 | | 1 | 00:00:01 |:Q1003| PCWP | | | |
| 54 | TABLE ACCESS BY INDEX ROWID | KDD_CAL | 1 | 19 | 1 | 00:00:01 | | | | | |
| 55 | INDEX UNIQUE SCAN | AK1_KDD_CAL | 1 | | 1 | 00:00:01 | | | | | |
| 56 | TABLE ACCESS BY INDEX ROWID | KDD_CAL | 1 | 19 | 1 | 00:00:01 | | | | | |
| 57 | INDEX UNIQUE SCAN | AK1_KDD_CAL | 1 | | 1 | 00:00:01 | | | | | |
| 58 | TABLE ACCESS BY INDEX ROWID | KDD_CAL | 1 | 19 | 1 | 00:00:01 | | | | | |
| 59 | INDEX UNIQUE SCAN | AK1_KDD_CAL | 1 | | 1 | 00:00:01 | | | | | |
---------------------------------------------------------------------------------+-----------------------------------+-------------------------+---------------+

该问题提交了SR，MOS给出的回复:”This is high likely caused by bug 4611578,bug 4611578 is complete fixed in 8397251.Parallel Execution plan shows a UNION ALL under a nested loop row source that is the bug pattern”。在使用并行的情况下存在UNION ALL PUSHED PREDICATE以合并某些由NESTED LOOP获得的数据源是引发该4611578 bug的典型情况。 Oracle GCS建议通过修改PUSHED PREDICATE的相关隐式参数来避免谓词前推的发生:

Please try if one of the following workaround help:

- alter session set "_optimizer_push_pred_cost_based" = false; or
- alter session set "_push_join_union_view" = false; or
- use hint NO_PUSH_PRED)

I can get backport for bug 8397251 on top of 10.2.0.4 10.2.0.5
See Doc 209768.1 and there section 5.2.2

The parameter _push_join_union_view chan switch off a optimization
for queries with UNION ALL and joins, so all queries with this pattern
can be affected, the better workaound is here to switch off parallelism.

设置隐式参数_push_join_union_view为false将禁用union all和join操作的pushed predicate特性，可能会影响到系统中其他SQL的性能；MOS认为最好的workaround方式是取消查询的并行度。这个case最后通过加入NO_PARALLEL提示解决了。