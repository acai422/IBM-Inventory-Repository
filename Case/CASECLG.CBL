 //T6ATA7CM JOB (EWF),'$_MAIN PROGRAM    !',                             
 //             CLASS=W,MSGCLASS=Y,NOTIFY=&SYSUID                        
 //EXPORTS  EXPORT SYMLIST=(*)                                           
 //JCLLIB   JCLLIB ORDER=(TNASC.PDS.CLASS2.LABJCL,                       
 //             PNASC.HRBCH.PROCPDS,                                     
 //             PNASC.HRBCH.INCLUDE)                                     
 //JCLOVER  INCLUDE MEMBER=@JCLOVER                                      
 //OUTPUTT  INCLUDE MEMBER=@OUTPUTT                                      
 //JOBLIB   INCLUDE MEMBER=@JBLMODL                                      
 //          DD DSN=TNASC.PDS.CLASS2.LOADLIB.LAB,DISP=SHR                
 //*                                                                     
 //         SET HL=T6ATA7C                                               
 //         INCLUDE MEMBER=NASCSET$                                      
 //*                                                                     
 //**************************************************************        
 //*                                                                     
 //*   MEMBER=CASECLG - COMPILE, BIND AND EXECUTE THE CASE STUDY         
 //*                                                                     
 //**************************************************************        
 //*                                                                     
 //STEP01  EXEC PROC=COBUCL,MEM=LOGGER                                   
 //STEP02  EXEC PROC=COBUCL,MEM=GETREC                                   
 //STEP03  EXEC PROC=COBUCL,MEM=RPTREC                                   
 //*TEP04  EXEC PROC=COBUCL,MEM=FMTREC                                   
 //*TEP04  EXEC PROC=COBUCL,MEM=FMTREC1                                  
 //*TEP04  EXEC PROC=COBUCL,MEM=FMTREC2                                  
 //*TEP04  EXEC PROC=COBUCL,MEM=FMTREC3                                  
 //STEP04  EXEC PROC=COBUCL,MEM=FMTREC4                                  
 //*TEP05  EXEC PROC=COBUCL,MEM=CATSUM                                   
 //*TEP06  EXEC PROC=COBUCL,MEM=BCHECK                                   
 //*TEP07  EXEC PROC=COBUCL,MEM=SUSPND                                   
 //STEP08  EXEC PROC=COBUCL,MEM=MAIN,BOPTMEM=NASCBOPB                    
 //*                                                                     
 //STEP99   EXEC PROC=COBCASE,                                           
 //   PARM.GO='INPUTB LIMITED REPORT WITH SUSPENSE'                      
 //*                                                                     
 //*STEP99B  EXEC PROC=COBSUSP                                           
