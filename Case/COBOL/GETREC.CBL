       identification division.                                         
       program-id. GETREC.                                              
       environment division.                                            
       input-output section.                                            
       file-control.                                                    
           SELECT IN-DATA-FILE ASSIGN TO CASEIN.                        
       data division.                                                   
       file section.                                                    
       FD IN-DATA-FILE.                                                 
       01 IN-DATA               PIC X(80).                              
       working-storage section.                                         
       linkage section.                                                 
      ***                                                               
      *** good place to define parameters                               
      ***                                                               
       01  PARM-REQUEST         pic x(1).                               
       01  PARM-OUTREC          pic x(80).                              
                                                                        
       procedure division using PARM-REQUEST PARM-OUTREC.               
           MOVE 0 TO RETURN-CODE                                        
           EVALUATE PARM-REQUEST                                        
              WHEN "1"                                                  
                 OPEN INPUT IN-DATA-FILE                                
              WHEN "2"                                                  
                 READ IN-DATA-FILE INTO PARM-OUTREC                     
                    AT END                                              
                    MOVE 4 TO RETURN-CODE                               
                 END-READ                                               
              WHEN "9"                                                  
                    CLOSE IN-DATA-FILE                                  
              WHEN OTHER                                                
                   CALL 'LOGGER' USING BY CONTENT                       
                               Z'GET001 BAD PARAMETER PASSED TO GETREC' 
           END-EVALUATE.                                                
                                                                        
           goback                                                       
           .                                                            
