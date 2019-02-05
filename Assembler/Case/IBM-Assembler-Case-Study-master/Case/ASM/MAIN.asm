MAIN     CSECT                                                        
*****************************************************************     
* STANDARD LINKAGE FOR A REUSABLE OS/MVS CSECT                        
*****************************************************************     
         SAVE  (14,12)              SAVE CALLER'S REGS                
         BASR  R12,0                ESTABLISH                         
         USING *,R12                ADDRESSABILITY                    
         LA    R2,SAVEAREA          POINT TO MY LOWER-LEVEL SA        
         ST    R2,8(,R13)           FORWARD-CHAIN MINE FROM CALLER'S  
         ST    R13,SAVEAREA+4       BACK-CHAIN CALLER'S FROM MINE     
         LR    R13,R2               SET 13 FOR MY SUBMAIN1 CALLS      
********************** BEGIN LOGIC *******************************    
START    LA    R3,FUNCT1                R3=FUNCTION CODE              
         BAS   R11,GETREC               R11=RETURN ADDRESS            
         LA    R3,FUNCT1                                              
         BAS   R11,RPTREC                                             
         LA    R3,FUNCT2                                              
         BAS   R11,FMTREC                                            
         LA    R3,FUNCT2                                              
         BAS   R11,RPTREC  
         LA    R3,FUNCT3               
         BAS   R11,FMTREC            
         LA    R3,FUNCT2               
         BAS   R11,RPTREC              
         LA    R3,FUNCT2               
         BAS   R11,GETREC              
                                        
LOOP     DS    0H                      
         CLI   ENDF,C'T'               
         BE    FINAL                   
         LA    R3,FUNCT1               
         BAS   R11,FMTREC             
         LA    R3,FUNCT2               
         BAS   R11,RPTREC              
         LA    R3,FUNCT2               
         BAS   R11,GETREC              
         B     LOOP                    
                                        
FINAL    DS    0H                      
         LA    R3,FUNCT99              
         BAS   R11,GETREC                       
         LA    R3,FUNCT99                         
         BAS   R11,RPTREC                         
         B     ALLDONE                            
                                                 
GETREC   DS    0H                                 
         CALL  GETREC,((R3),DEFINPUT)             
         C     R15,=F'0'                          
         BNE   CHECK4                             
         BR    R11                                
                                                  
RPTREC   DS    0H                                 
         CALL  RPTREC,((R3),DEFOUTPUT)            
         C     R15,=F'0'                          
         BNE   ERRORRPT                           
         BR    R11                                
                                                  
FMTREC   DS    0H                                 
         CALL  FMTREC,((R3),DEFINPUT,DEFOUTPUT)  
         C     R15,=F'0'                          
         BNE   ERRORFMT                           
         BR    R11                                         
                                        
CHECK4   DS    0H                      
         C     R15,=F'4'               
         BNE   GETERR                  
         MVC   ENDF,=C'T'              
         BR    R11                     
                                       
GETERR   DS    0H                      
         LA    R2,CAS001               
         WTO   TEXT=(R2),ROUTCDE=11    
         B     ALLDONE                 
                                       
ERRORRPT DS    0H                      
         LA    R2,CAS002               
         WTO   TEXT=(R2),ROUTCDE=11    
         B     ALLDONE                 
                                       
ERRORFMT DS    0H                      
         LA    R2,CAS003               
         WTO   TEXT=R2,ROUTCDE=11      
         B     ALLDONE 
                                                                       
ALLDONE  WTO   'EXITING MAIN1',ROUTCDE=11                             
********************** END LOGIC   *******************************    
         L     R13,SAVEAREA+4       POINT TO CALLER'S SAVE AREA       
         RETURN (14,12),RC=0        RESTORE CALLER'S REGS & RETURN    
********************** DATA AREAS  *******************************    
TEMPVAR  DC     CL133' '                                              
ENDF     DC     C'F'                                                  
                                                                      
DEFINPUT DS     0CL100                                                
         COPY   DEFINPUT                                              
                                                                      
DEFOUTPUT DC    CL133' '                                              
                                                                      
FUNCT1   DC     F'1'                                                  
FUNCT2   DC     F'2'                                                  
FUNCT3   DC     F'3'                                                  
FUNCT99  DC     F'99'                                                 
CAS001   EMSG   'GET ERROR'                                           
CAS002   EMSG   'REPORT ERROR'                                        
CAS003   EMSG   'FORMAT ERROR'                                        
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
         END  MAIN                                                  
