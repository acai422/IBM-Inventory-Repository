       identification division.                                         
       program-id. MAIN.                                                
       environment division.                                            
       data division.                                                   
       working-storage section.                                         
       01 IN-DATA          PIC X(80).                                   
       01 OUT-DATA         PIC X(133).                                  
                                                                        
       01 COUNTER          PIC 99 VALUE 0.                              
       01 EXTERN-TITLE     PIC X(40) EXTERNAL.                          
       procedure division.                                              
       MAINLINE.                                                        
           move 0 to RETURN-CODE                                        
           MOVE 0 TO COUNTER                                            
                                                                        
           call 'LOGGER' using by content z'CAS001: Starting program'   
           perform INITIALIZATION                                       
           perform DOTHEWORK UNTIL RETURN-CODE = 4                      
           perform TERMINATION                                          
           call 'LOGGER' using by content z'CAS999: All done'           
           goback                                                       
           .                                                            
                                                                        
       INITIALIZATION.                                                  
           CALL 'GETREC' USING                                          
           BY CONTENT '1'                                               
           BY REFERENCE IN-DATA                                         
                                                                        
           CALL 'RPTREC' USING                                          
           BY CONTENT '1'                                               
           BY REFERENCE OUT-DATA                                        
                                                                        
           CALL 'FMTREC4' USING                                         
           BY CONTENT '4'                                               
           BY REFERENCE IN-DATA, OUT-DATA                               
                                                                        
           CALL 'RPTREC' USING                                          
           BY CONTENT '2'                                               
           BY REFERENCE OUT-DATA                                        
                                                            
            CALL 'FMTREC4' USING                            
            BY CONTENT '2'                                  
            BY REFERENCE IN-DATA, OUT-DATA                  
                                                            
            CALL 'RPTREC' USING                             
            BY CONTENT '2'                                  
            BY REFERENCE OUT-DATA                           
                                                            
            CALL 'FMTREC4' USING                            
            BY CONTENT '3'                                  
            BY REFERENCE IN-DATA, OUT-DATA                  
                                                            
            CALL 'RPTREC' USING                             
            BY CONTENT '2'                                  
            BY REFERENCE OUT-DATA                           
                                                            
            CALL 'GETREC' USING                             
            BY CONTENT '2'                                  
            BY REFERENCE IN-DATA                            
                                                            
            continue                                        
            .                                               
                                                            
        DOTHEWORK.                                          
            CALL 'FMTREC4' USING                            
            BY CONTENT '1'                                  
            BY REFERENCE IN-DATA, OUT-DATA                  
                                                            
            CALL 'RPTREC' USING                             
            BY CONTENT '2'                                  
            BY REFERENCE OUT-DATA                           
                                                            
            CALL 'GETREC' USING                             
            BY CONTENT '2'                                  
            BY REFERENCE IN-DATA                            
                                                            
            ADD 1 TO COUNTER                                
            IF COUNTER = 40                                 
               PERFORM GET-FOOTER                           
              PERFORM GET-HEADER                         
              INITIALIZE COUNTER                         
           END-IF                                        
           continue                                      
           .                                             
      *** 3                                              
       GET-FOOTER.                                       
           CALL 'FMTREC4' USING                       
           BY CONTENT '5'                             
           BY REFERENCE IN-DATA, OUT-DATA             
                                                         
           CALL 'RPTREC' USING                        
           BY CONTENT '2'                             
           BY REFERENCE OUT-DATA                      
                                                         
           CALL 'FMTREC4' USING                       
           BY CONTENT '6'                             
           BY REFERENCE IN-DATA, OUT-DATA             
                                                         
           CALL 'RPTREC' USING                        
           BY CONTENT '2'                             
           BY REFERENCE OUT-DATA                      
           .                                             
      ***                                                
       GET-HEADER.                                       
           CALL 'FMTREC4' USING                       
           BY CONTENT '3'                             
           BY REFERENCE IN-DATA, OUT-DATA             
                                                         
           CALL 'RPTREC' USING                        
           BY CONTENT '2'                             
           BY REFERENCE OUT-DATA                      
                                                         
           CALL 'FMTREC4' USING                       
           BY CONTENT '4'                             
           BY REFERENCE IN-DATA, OUT-DATA             
                                                         
           CALL 'RPTREC' USING                        
           BY CONTENT '2'                             
           BY REFERENCE OUT-DATA                  
                                                   
           CALL 'FMTREC4' USING                   
           BY CONTENT '2'                         
           BY REFERENCE IN-DATA, OUT-DATA         
                                                   
           CALL 'RPTREC' USING                    
           BY CONTENT '2'                         
           BY REFERENCE OUT-DATA                  
                                                   
           CALL 'FMTREC4' USING                   
           BY CONTENT '3'                         
           BY REFERENCE IN-DATA, OUT-DATA         
                                                   
           CALL 'RPTREC' USING                    
           BY CONTENT '2'                         
           BY REFERENCE OUT-DATA                  
                                                     
              .                                        
                                                     
        TERMINATION.                                  
           PERFORM GET-FOOTER                        
                                                    
           CALL 'FMTREC4' USING                      
           BY CONTENT '7'                            
           BY REFERENCE IN-DATA, OUT-DATA            
                                                      
           CALL 'RPTREC' USING                       
           BY CONTENT '2'                            
           BY REFERENCE OUT-DATA                     
                                                     
           CALL 'GETREC' USING                       
           BY CONTENT '9'                            
           BY REFERENCE IN-DATA                      
                                                    
           CALL 'RPTREC' USING                       
           BY CONTENT '9'                            
           BY REFERENCE OUT-DATA                     
                                                    
           continue                                  
           .             
