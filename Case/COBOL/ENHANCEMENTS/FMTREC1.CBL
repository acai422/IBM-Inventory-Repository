       identification division.                                         
       program-id. FMTREC1.                                             
       environment division.                                            
       data division.                                                   
       working-storage section.                                         
       01  WS-STUFF.                                                    
           05  WS-INREC.                                                
       copy DEFINP.                                                     
           05  WS-DETAIL.                                               
               10                  PIC X       VALUE SPACES.            
               10 D-PART-NUM       PIC X(09).                           
               10                  PIC X(06)   VALUE SPACES.            
               10 D-DESCRIPTION    PIC X(30).                           
               10                  PIC X(04)   VALUE SPACES.            
               10 D-UNIT-PRICE     PIC $$$9.99.                         
              identification division.                                  
               10 D-QUANT-ON-HAND  PIC 09(05).                          
              program-id. FMTREC1.                                      
               10 D-QUANT-ON-ORDER PIC 09(02).                          
              environment division.                                     
               10 D-REORDER-LEVEL  PIC 09(02).                          
              data division.                                            
               10                  PIC X(05)   VALUE SPACES.            
              working-storage section.                                  
               10                  PIC X(05)   VALUE SPACES.            
              01  WS-STUFF.                                             
               10                  PIC X(04)   VALUE SPACES.            
                  05  WS-INREC.                                         
               10                  PIC X(22)   VALUE SPACES.            
      *       copy DEFINP.                                              
      *        place to define output record                            
      *           05  WS-DETAIL.                                        
               WS-COLHDR.                                               
                      10                  PIC X       VALUE SPACES.     
               10                  PIC X(11)   VALUE 'PART NUMBER'.     
                      10 D-PART-NUM       PIC X(09).                    
               10                  PIC X(30)   VALUE 'DESCRIPTION'.     
                      10                  PIC X(06)   VALUE SPACES.     
               10                  PIC X(10)   VALUE 'UNIT PRICE'.      
               10                  PIC X(03)   VALUE SPACES.            
               10                  PIC X(07)   VALUE 'ON HAND'.         
               10                  PIC X(04)   VALUE SPACES.            
               10                  PIC X(08)   VALUE 'ON ORDER'.        
               10                  PIC X(01)   VALUE SPACES.            
      ***      10                  PIC X(11)   VALUE 'REORDER LVL'.     
               10                  PIC X(03)   VALUE 'FLG'.             
               10                  PIC X(03)   VALUE SPACES.            
               10                  PIC X(12)   VALUE 'OLD PART NUM'.    
               10                  PIC X(02)   VALUE SPACES.            
               10                  PIC X(13)   VALUE 'ITEM CATEGORY'.   
               10                  PIC X(04)   VALUE SPACES.            
               10                  PIC X(10)   VALUE 'ITEM VALUE'.      
               10                  PIC X(22)   VALUE SPACES.            
                                                                        
      ***                                                               
      *** good place to define column header                            
      ***                                                               
       linkage section.                                                 
      ***                                                               
      *** good place to define parameters                               
      ***                                                               
       01  PARM-REQUEST         pic X(1).                               
       01  PARM-INREC           PIC X(80).                              
       01  PARM-OUTREC          pic X(133).                             
                                                                        
       procedure division using PARM-REQUEST PARM-INREC PARM-OUTREC.    
           EVALUATE PARM-REQUEST                                        
              WHEN "1"                                                  
                                                                        
                 MOVE PARM-INREC TO WS-INREC                            
                 DISPLAY WS-INREC                                       
                 MOVE I-PARTNO   TO D-PART-NUM                          
                 MOVE I-DESCR    TO D-DESCRIPTION                       
                 MOVE I-UNITPR   TO D-UNIT-PRICE                        
                 MOVE I-QOH      TO D-QUANT-ON-HAND                     
                 MOVE I-QOO      TO D-QUANT-ON-ORDER                    
      ***        MOVE I-RDRLVL   TO D-REORDER-LEVEL                     
                                                                        
                 IF I-QOH + I-QOO < I-RDRLVL                            
                    MOVE '*'     TO D-REORDER-FLAG        
                 ELSE                                     
                    MOVE ' '     TO D-REORDER-FLAG        
                 END-IF                                   
      ***                                                 
                 COMPUTE D-ITEM-VALUE = I-QOH * I-UNITPR  
                                                          
                 MOVE I-OLDPTNO  TO D-OLD-PART-NUM        
                 MOVE I-ITEMCAT  TO D-ITEM-CATEGORY       
                 MOVE WS-DETAIL  TO PARM-OUTREC           
                                                          
              WHEN "2"                                    
                 MOVE WS-COLHDR TO PARM-OUTREC            
                                                          
              WHEN "3"                                    
                 MOVE SPACES TO PARM-OUTREC               
           END-EVALUATE.                                  
           goback                                         
           .                                              
