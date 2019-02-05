RPTREC  CSECT                                                          
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
START    LR    R2,R1                                                   
         LM    R3,R4,0(R2)    SEPARATE THE ADDRESS OF FUNCTION CODE AND
         L     R6,0(R3)       R6 HAS FUNCTION CODE                     
         C     R6,=F'1'       CHECKING IF CODE IS 01                   
         BE    OPENF                                                   
         C     R6,=F'2'       CHECKING IF CODE IS 02                   
         BE    WRITEI                                                  
         C     R6,=F'99'      CHECKING IF CODE IS 99                   
         BE    CLOSEF                                                  
         B     OTHER                                                   
                                                                       
OPENF    OPEN  (OUTFILE,OUTPUT)                                        
         TM    OUTFILE+DCBOFLGS-IHADCB,X'10'                           
         BNO   OPENERR                                         
         B     DONE                                            
                                                               
WRITEI   DS    0H                                              
         PUT   OUTFILE,(R4)                                    
         LA    R15,0                                           
         B     DONE                                            
                                                               
CLOSEF   CLOSE (OUTFILE)                                       
         TM    OUTFILE+DCBOFLGS-IHADCB,X'10'                   
         BO    CLOSEERR                                        
         B     DONE                                            
                                                               
OPENERR  LA    R15,8                                           
         LA    R2,CAS001                                       
         WTO   TEXT=(R2),ROUTCDE=11                            
         B     DONE                                            
NEXTERR  LA    R2,CAS002                                       
         WTO   TEXT=(R2),ROUTCDE=11                            
         B     DONE                                            
CLOSEERR LA    R15,8                                           
         LA    R2,CAS003                                       
         WTO   TEXT=(R2),ROUTCDE=11                            
         B     DONE                                            
OTHER    LA    R15,8                                           
         LA    R2,CAS004                                       
         WTO   TEXT=(R2),ROUTCDE=11                                 
         B     DONE                                                 
ENDFILE  LA    R15,4                                                
DONE     DS    0H                                                   
********************** END LOGIC   *******************************  
         L     R13,SAVEAREA+4       POINT TO CALLER'S SAVE AREA     
         RETURN (14,12),RC=(15)    RESTORE CALLER'S REGS & RETURN   
********************** DATA AREAS  *******************************  
CAS001   EMSG  'OPEN ERROR'                                         
CAS002   EMSG  'NEXT ERROR; FILE NOT OPENED'                        
CAS003   EMSG  'CLOSE ERROR'                                        
CAS004   EMSG  'NOT 1,2,OR 99'                                      
OUTFILE  DCB   DSORG=PS,                                           *  
               MACRF=(PM),                                         * 
               DDNAME=OUTFILE,RECFM=FBA,LRECL=133                   
SAVEAREA DC    18F'0'                                               
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
         DCBD DSORG=PS                       
         END  RPTREC                                               
