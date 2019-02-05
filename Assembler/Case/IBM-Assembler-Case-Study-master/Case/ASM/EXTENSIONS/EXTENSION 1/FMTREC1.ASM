 FMTREC1  CSECT                                                       
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
          LM    R3,R5,0(R2)    R3=FUNCCODE;R4=INPUTI/O;R5=OUTPUTI/0   
          L     R6,0(R3)       R6 HAS FUNCTION CODE                   
          C     R6,=F'1'       CHECKING IF CODE IS 01                 
          BE    INPUTIO                                               
          C     R6,=F'2'       CHECKING IF CODE IS 02                 
          BE    HEADERIO                                              
          C     R6,=F'3'       CHECKING IF CODE IS 3
          BE    BLANKS                                                  
          B     OTHER                                                   
                                                                       
INPUTIO   MVI   OUTSTUFF,C' '              CLEARING OUT OUTPUT          
          MVC   OUTSTUFF+1(L'OUTSTUFF-1),OUTSTUFF                       
          MVC   DEFINPUT,0(R4)                                          
          MVC   NUMO,PARTNO                LOADING PARTNUM INTO OUTPUT  
          MVC   DESCO,DESC                 LOADING DESC INTO OUTPUT     
          MVC   UNITPO(L'UNITPO),PRICEPAT  MOVING PATTERN TO UNIT PRICE 
          LA    R1,UNITPO+8                                             
          EDMK  UNITPO(L'PRICEPAT),UNITP   EDITING AND ADDING MARK ($)  
          BCTR  R1,0                                                    
          MVI   0(R1),X'5B'                DEFINING $                   
          MVC   QUANTHO(L'QUANTHO),QNTHPAT MOVING PATTERN TO ON HAND    
          LA    R1,QUANTHO+8                                            
          ED    QUANTHO(L'QNTHPAT),QUANTH  EDITING TO MATCH OUTPUT      
          LH    R1,QUANTO                  LOADING HALFWORD TO R1       
          CVD   R1,QUANTOOST               CONVERT TO PACKED DECIMAL    
          MVC   QUANTOO(L'QUANTOO),QNTOPAT MOVE PATTERN TO OUTPUT       
          ED    QUANTOO(L'QNTOPAT),QUANTOOST+5 MOVE STORAGE TO OUPUT    
          LH    R1,REORDER    
          CVD   R1,REORDERST                     
          MVC   REORDERO(L'REORDERO),REORDPAT    
          ED    REORDERO(L'REORDPAT),REORDERST+5 
          MVC   ITEMCATO,ITEMCAT                 
          MVC   0(L'OUTSTUFF,R5),OUTSTUFF        
          LA    R15,0                            
          B     DONE                             
                                                 
 HEADERIO DS    0H                               
          MVI   OUTSTUFF,C' '                    
          MVC   OUTSTUFF+1(L'OUTSTUFF-1),OUTSTUFF
          MVC   OUTSTUFF,HEADER                  
          MVC   0(L'OUTSTUFF,R5),OUTSTUFF        
          LA    R15,0                            
          B     DONE                             
                                                 
 BLANKS   MVI   OUTSTUFF,C' '                    
          MVC   OUTSTUFF+1(L'OUTSTUFF-1),OUTSTUFF
          MVC   0(L'OUTSTUFF,R5),OUTSTUFF        
          LA    R15,0                            
          B     DONE
                                                                     
 OTHER    LA    R2,CAS004                                           
          WTO   TEXT=(R2),ROUTCDE=11                                
          LA    R15,8                                               
          B     DONE                                                
                                                                    
 ENDFILE  LA    R15,4                                               
 DONE     DS    0H                                                  
 ********************** END LOGIC   ******************************* 
          L     R13,SAVEAREA+4       POINT TO CALLER'S SAVE AREA    
          RETURN (14,12),RC=(15)    RESTORE CALLER'S REGS & RETURN  
 ********************** DATA AREAS  ******************************* 
 CAS004   EMSG  'NOT 1,2,OR 3'                                      
 QUANTOOST DS   D                                                   
 REORDERST DS   D                                                   
 DEFINPUT DS    0CL100                                              
          COPY  DEFINPUT                                            
 HEADER   DS    0CL133                                              
 NUMH     DC    C' PART NUMBER'                                     
          DC    CL03' '                                             
 DESH     DC    C'DESCRIPTION'   
          DC    CL24' '              
 PRICEH   DC    C'UNIT PRICE'        
          DC    CL03' '              
 QUANTHH  DC    C'ON HAND'           
          DC    CL2' '               
 QUANTOH  DC    C'ON ORDER'          
          DC    CL02' '              
 REORDERH DC    C'REORDER LEVEL'     
          DC    CL02' '              
 *OLDH     DC    C'OLD PART NUMBER'  
 *         DC    C' '                
 CATITEMH DC    C'ITEM CATEGORY'     
          DC    CL46' '              
                                     
OUTSTUFF DS    0CL133               
         DC    C' '                 
NUMO     DS    CL09                 
         DC    CL05' '              
DESCO    DS    CL30                 
         DC    CL02' '              
UNITPO   DS    CL09
         DC    CL03' '                 
QUANTHO  DS    CL06                    
         DC    CL04' '                 
QUANTOO  DS    CL06                    
         DC    CL04' '                 
REORDERO DS    CL06                    
*OLDNOO   DS    CL09                   
         DC    CL12' '                 
ITEMCATO DS    CL10                    
         DC    CL31' '                 
                                       
BLANKIO  DC    CL133' '                
                                       
PRICEPAT DC    XL09'40206B2020214B2020'
QNTHPAT  DC    XL06'402020202020'      
QNTOPAT  DC    XL06'402020202020'      
REORDPAT DC    XL06'402020202020'      
                                       
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
         END  FMTREC1   
