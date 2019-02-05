CALCFLDS CSECT                                                          
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
         LR    R2,R1                                                    
         LM    R3,R5,0(R2)                                              
                                                                        
CHECKFLG DS    0H                                                       
         MVC   INFILE,0(R3)                                             
         ZAP   QUANTHST,QUANTH                                          
         LH    R1,QUANTO                                                
         CVD   R1,QUANTOST                                              
         LH    R1,REORDER                                               
         CVD   R1,REORDERST                                             
         AP    QUANTOST,QUANTHST                                        
         CP    QUANTOST,REORDERST                                       
         BL    ASTERISK                                                
         MVI   0(R4),C' '                                              
         B     ITEMVAL                                                 
                                                                        
ASTERISK DS    0H                                                      
         MVI   0(R4),C'*'                                              
         B     ITEMVAL                                                 
                                                                        
ITEMVAL  DS    0H                                                      
         ZAP   PRICEPROD,UNITP                                         
         MP    PRICEPROD,QUANTHST                                      
         SRP   PRICEPROD,64-1,5                                        
         ZAP   0(5,R5),PRICEPROD                                       
                                                                       
DONE     DS    0H                                                      
********************** END LOGIC   *******************************     
         L      R13,SAVEAREA+4     POINT TO CALLER'S SAVE AREA         
         RETURN (14,12),RC=(15)    RESTORE CALLER'S REGS & RETURN      
********************** DATA AREAS  *******************************     
QUANTHST  DS    PL5                                                    
PRICEPROD DS    PL10                                                   
QUANTOST  DS    D                                                      
REORDERST DS    D                                                      
                                                                       
INFILE    DS    0CL100                                                 
                COPY DEFINPUT                                          
                                                                        
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
         END  CALCFLDS
