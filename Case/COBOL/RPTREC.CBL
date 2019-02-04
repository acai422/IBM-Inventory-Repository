       identification division.                                         
       program-id. RPTREC.                                              
       environment division.                                            
       input-output section.                                            
       file-control.                                                    
           SELECT OUT-DATA-FILE ASSIGN TO CASERPT.                      
       data division.                                                   
       file section.                                                    
       FD OUT-DATA-FILE.                                                
       01 OUT-DATA              PIC X(133).                             
       working-storage section.                                         
       linkage section.                                                 
      ***                                                               
      *** good place to define parameters                               
      ***                                                               
       01  PARM-REQUEST         pic X(1).                               
       01  PARM-OUTREC          pic X(133).                             
                                                                        
       procedure division using PARM-REQUEST PARM-OUTREC.               
           EVALUATE PARM-REQUEST                                        
              WHEN "1"                                                  
                 OPEN OUTPUT OUT-DATA-FILE                              
              WHEN "2"                                                  
                 WRITE OUT-DATA FROM PARM-OUTREC                        
              WHEN "9"                                                  
                 CLOSE OUT-DATA-FILE                                    
              WHEN OTHER                                                
                 CALL 'LOGGER' USING BY CONTENT                         
                      Z'RPT001 BAD PARAMETER PASSED TO RPTREC'          
           END-EVALUATE.                                                
           goback                                                       
           .                                                            
