TESTMAC  CSECT                                                          
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
         LA    R2,CAS000                                                
         WTO   TEXT=(R2),ROUTCDE=11                                     
********************** END LOGIC   *******************************      
         L     R13,SAVEAREA+4       POINT TO CALLER'S SAVE AREA         
         RETURN (14,12),RC=0        RESTORE CALLER'S REGS & RETURN      
********************** DATA AREAS  *******************************      
CAS000   EMSG  'PROGRAM STARTED'                                        
SAVEAREA DC    18F'0'       AREA FOR CALLEE TO SAVE & RESTORE MY REGS   
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
         END  TESTMAC                                
