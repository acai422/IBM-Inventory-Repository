       identification division.                                         
       program-id. LOGGER.                                              
       data division.                                                   
       working-storage section.                                         
      ***                                                               
      *** good place to CEEMOUT parameters                              
      ***                                                               
       01  LE-MSG-STUFF.                                                
           05  LE-DEST          pic S9(09) BINARY VALUE 2.              
           05  LE-FC            pic X(12).                              
           05  LE-MSG.                                                  
               10  LE-MSG-LEN   pic S9(04) BINARY.                      
               10  LE-MSG-TEXT  pic x(255).                             
       linkage section.                                                 
      ***                                                               
      *** good place to define input parameter                          
      ***                                                               
       01  MSG-IN               pic x(255).                             
                                                                        
       procedure division  using MSG-IN.                                
           MOVE 0 TO LE-MSG-LEN                                         
           INSPECT MSG-IN TALLYING LE-MSG-LEN                           
              FOR CHARACTERS BEFORE X'00'                               
           MOVE MSG-IN(1:LE-MSG-LEN) TO LE-MSG-TEXT(1:LE-MSG-LEN)       
           CALL 'CEEMOUT' USING LE-MSG, LE-DEST, LE-FC                  
           goback                                                       
           .                                                            
