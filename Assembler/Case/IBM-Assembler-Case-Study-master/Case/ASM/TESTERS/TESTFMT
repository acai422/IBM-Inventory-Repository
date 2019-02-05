         TITLE 'CASE STUDY - TEST GENERIC ROUTINE'                      
TESTFMT  CSECT                                                          
*****************************************************************       
* STANDARD LINKAGE FOR A REUSABLE OS/MVS CSECT                          
*****************************************************************       
         SAVE  (14,12)              SAVE CALLER'S REGS                  
         BASR  R12,0                ESTABLISH                           
         USING *,R12                ADDRESSABILITY                      
         LA    R2,SAVEAREA          POINT TO MY LOWER-LEVEL SA          
         ST    R2,8(,R13)           FORWARD-CHAIN MINE FROM CALLER'S    
         ST    R13,SAVEAREA+4       BACK-CHAIN CALLER'S FROM MINE       
         LR    R13,R2               SET 13 FOR MY SUBROUTINE CALLS      
********************** BEGIN LOGIC *******************************      
START    DS    0H                                                       
         CALL  FMTREC,(FUNCTCO1,DEFINPUT,DEFOUT)                        
         LA    R1,SNAPPARM1                                             
         CALL  SNAPPER                                                  
         CALL  FMTREC,(FUNCTCO2,DEFINPUT,DEFOUT)                        
         LA    R1,SNAPPARM2                                             
         CALL  SNAPPER                                                  
         CALL  FMTREC,(FUNCTCO3,DEFINPUT,DEFOUT)                        
         LA    R1,SNAPPARM3                                             
         CALL  SNAPPER                                                  
         L     R13,SAVEAREA+4       POINT TO CALLER'S SAVE AREA         
         PRINT GEN                                                      
         RETURN (14,12),RC=0        RESTORE CALLER'S REGS & RETURN      
********************** DATA AREAS ******************************        
FUNCTCO1 DC    F'1'                                                     
FUNCTCO2 DC    F'2'                                                     
FUNCTCO3 DC    F'3'                                                     
SAVEAREA DC    18F'0'       AREA FOR CALLEE TO SAVE & RESTORE MY REGS   
SNAPPARM1 DC   A(DUMPSPOT),AL2(DUMPLEN),H'1'                            
SNAPPARM2 DC   A(DUMPSPOT),AL2(DUMPLEN),H'2'                            
SNAPPARM3 DC   A(DUMPSPOT),AL2(DUMPLEN),H'3'                            
DEFINPUT DS    0CL100                                                   
PARTNO   DC    CL09'THREE'                                              
DESC     DC    CL30'CELL PHONE'                                         
         DS    CL05                                                     
UNITP    DC    PL04'4.20'                                               
QUANTH   DC    PL03'1'                                                  
         DS    CL01                                                     
QUANTO   DC    HL02'1'                                                  
REORDER  DC    HL02'2'                                                  
         DS    CL01                                                     
OLDNO    DC    CL09'ONE'                                                
         DS    CL01                                                     
ITEMCAT  DC    CL10'PHONE'                                              
         DS    CL23                                                     
DUMPSPOT DS    0D                                                       
         DC    CL8'EYEBALL'                                             
DEFOUT   DS    CL133                                                    
         DC    CL8'ENDBALL'                                             
DUMPLEN  EQU   *-DUMPSPOT                                               
         LTORG                                                          
*                                                                       
R0       EQU   0                                                        
R1       EQU   1                                                        
R2       EQU   2                                                        
R3       EQU   3                                                        
R4       EQU   4                                                        
R5       EQU   5                                                        
R6       EQU   6                                                        
R7       EQU   7                                                        
R8       EQU   8                                                        
R9       EQU   9                                                        
R10      EQU  10                                                        
R11      EQU  11                                                        
R12      EQU  12                                                        
R13      EQU  13                                                        
R14      EQU  14                                                        
R15      EQU  15                                                        
         END  TESTFMT                                                   
