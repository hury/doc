Oracle 设置监听器密码(LISTENER)

    监听器也有安全？Sure！在缺省的情况下，任意用户不需要使用任何密码即通过lsnrctl 工具对Oracle Listener进行操作或关闭，从
而造成任意新的会话都将无法建立连接。在Oracle 9i 中Oracle监听器允许任何一个人利用lsnrctl从远程发起对监听器的管理。也容易导致数
据库受到损坏。

1. 未设定密码情形下停止监听       

[oracle@test ~]$ lsnrctl stop listener_demo92   -->停止监听，可以看出不需要任何密码即可停止   
                                                                                             
LSNRCTL for Linux: Version 9.2.0.8.0 - Production on 26-JUN-2011 08:22:26                    
                                                                                             
Copyright (c) 1991, 2006, Oracle Corporation.  All rights reserved.                          
                                                                                             
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=test)(PORT=1521)))                   
The command completed successfully                                                           
                                                     
2. 重新启动监听并设置密码

[oracle@test ~]$ lsnrctl                         
                                                                                                                           
LSNRCTL for Linux: Version 9.2.0.8.0 - Production on 26-JUN-2011 08:24:09                                                  
Copyright (c) 1991, 2006, Oracle Corporation.  All rights reserved.                                                        

Welcome to LSNRCTL, type "help" for information. 

LSNRCTL> set current_listener listener_demo92  -->设置当前监听器                                                            
Current Listener is listener_demo92    

LSNRCTL> start             -->启动过程也不需要任何密码,启动的详细信息省略                                                   
LSNRCTL> change_password   -->使用change_password来设置密码                                                                 
Old password:                                                                                                              
New password:                                                                                                              
Reenter new password:                                                                                                      
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=test)(PORT=1521)))                                                 
Password changed for listener_demo92                                                                                       
The command completed successfully   
                                                                                     
LSNRCTL> save_config        -->注意此处的save_config失败                                                                    
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=test)(PORT=1521)))                                                 
TNS-01169: The listener has not recognized the password
                                                                 
LSNRCTL> set password       -->输入新设定的密码验证                                                                         
Password:                                                                                                                  
The command completed successfully   
                                                                                     
LSNRCTL> save_config       -->再次save_config成功
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=test)(PORT=1521)))                                                 
Saved listener_demo92 configuration parameters.                                                                            
Listener Parameter File   /oracle/92/network/admin/listener.ora                                                            
Old Parameter File   /oracle/92/network/admin/listener.bak                                                                 
The command completed successfully                                                                                         
                                                                                                                           
-->增加密码之后可以看到listener.ora文件中有一条新增的记录，即密码选项(注：尽管使用了密码管理方式,仍然可以无需密码启动监听)  
[oracle@test admin]$ more listener.ora                                                                                     
    #----ADDED BY TNSLSNR 26-JUN-2011 05:12:48---                                                                             
    PASSWORDS_listener_demo92 =                                                                                              
    #--------------------------------------------                                                                            
   
3. 尝试未使用密码的情况下停止监听

[oracle@test ~]$ lsnrctl stop listener_demo92                                                
LSNRCTL for Linux: Version 9.2.0.8.0 - Production on 26-JUN-2011 06:09:51                    
Copyright (c) 1991, 2006, Oracle Corporation.  All rights reserved.                          
                                                                                             
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=test)(PORT=1521)))                   
TNS-01169: The listener has not recognized the password    -->收到错误信息，需要使用密码认证 

4. 使用密码来停止监听  

[oracle@test ~]$ lsnrctl
                                                       
LSNRCTL> set current_listener listener_demo92                                   
Current Listener is listener_demo92         
                                   
LSNRCTL> stop                                                                   
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=test)(PORT=1521)))      
TNS-01169: The listener has not recognized the password  
                      
LSNRCTL> set password                                                           
Password:                                                                       
The command completed successfully  
                                           
LSNRCTL> stop                                                                   
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=test)(PORT=1521)))      
The command completed successfully  
                                                                                                                                                               
5. save_config失败的问题  

-->在 Oracle 9i中，使用save_config命令将会失败                                                                           
    LSNRCTL> save_config                                                                                                  
    Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=)(PORT=)))                                    
    TNS-01169: The listener has not recognized the password                                                               
                                                                                                                        
-->应该先使用set password之后再save_config，则保存配置成功。                                                             
    LSNRCTL> set password                                                                                                 
    Password:                                                                                     
    The command completed successfully                                                                                    
                                                       
6.  配置listener.ora中ADMIN_RESTRICTIONS参数

    参数作用：
        当在listener.ora文件中设置了ADMIN_RESTRICTIONS参数后，在监听器运行时，不允许执行任何管理命令，同时set命令将不可用
        ，不论是在服务器本地还是从远程执行都不行。此时对于监听的设置仅仅通过手工修改listener.ora文件，要使修改生效，只能
        使用lsnrctl reload命令或lsnrctl stop/start命令重新载入一次监听器配置信息。
       
    修改方法：
        在listener.ora文件中手动加入下面这样一行

        ADMIN_RESTRICTIONS_<监听器名> = ON

转自：http://blog.csdn.net/robinson_0612/article/details/6629249