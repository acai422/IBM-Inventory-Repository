IBM INVENTORY REPOSITORY - WIP

# IBM COBOL CASE STUDY ##
## Purpose: A Case Study developed by Hunter Cobb from IBM to test our COBOL knowledge 
### Task: An organization has a sequential file that is the master file for items in the company's inventory.

# Functional Requirement: 

The organization needs a report of the items in the inventory. The program will record records from the inventory master file, format the records for presentation, and produce a report file.

**Input File Format**

FIELD            | DATA TYPE           | LENGTH          
-----------------|---------------------|---------------------------------------
PART NUMBER      | CHARACTER           | 9              
DESCRIPTION      | CHARACTER           | 30              
UNUSED           | CHARACTER           | 05             
UNIT PRICE       | PACKED DECIMAL      | 04 (7 DIGITS TOTAL, 3 AFTER DECIMAL)
QUANTITY ON HAND | PACKED DECIMAL      | 03 (5 DIGITS TOTAL)
UNUSED           | CHARACTER           | 01          
QUANTITY ON ORDER| BINARY HALFWORD     | 02        
REORDER LEVEL    | BINARY HALFWORD     | 02          
UNUSED           | CHARACTER           | 01
OLD PART NUMBER  | CHARACTER           | 09
UNUSED           | CHARACTER           | 01
ITEM CATEGORY    | CHARACTER           | 10
UNUSED           | CHARACTER           | 23

Logical Record Length:80  
DDNAME: CASEIN  
Copy Library Member: DEFINP

## Report File Record Layout
Report will be a columnar style report, written as a SYSOUT-type file, viewable via SDSF  
There will be multiple output record types; content specified in the module specifications.  

DDNAME: CASERPT

## Design Overview

The program is to consist of several separately coded modules, to facilitate code reuse and to enable easier modifications. The modules should be coded and tested, first individually, and then together.

COBOL sequential I/O should be used for all file accesses.

Standard operating system linkage should be used for inter-program communication (except for SNAPPER).

Initially there should be five program modules:
1) MAIN: Main program to drive the overall program logic
2) GETREC: Subroutine to provide MAIN with records from the input file. All references to the input file should be contained in GETREC
3) FMTREC: Subroutine to format a report record, based on a record from the input file
4) RPTREC: Subroutine to output a record to a report file (which will be a SYSOUT-type file in the execution JCL). All references to the report file should be contained in the RPTREC.
5) LOGGER: Issue message via CEEMOUT Language Enviornment routine.

There should also be one copy library member - DEFINP - that contains the structure that maps the input record.

# INITIAL PSEUDO-CODE

## MAIN PROGRAM ##

**MAIN:** program to produce inventory report

**Parameters:** 
- Initially, none (invoked from JCL)

**Processing:**
- MAIN should read through the records of the input master file, producing one detail line for each record on the input file. Before the first detail line, there should be a column header line and a blank line.

- MAIN should use LOGGER to produce a (non-error) message at the beginning of execution, saying that the program was entered, and another (non-error) message at the end of execution, saying that the program was finished.

**Pseudo-code:**


Standard assember program entry  
Invoke GETREC to open input file  
Invoke RPTREC to open report file  
Invoke FMTREC to format a column header  
Invoke RPTREC to output column header  
Invoke FMTREC to format a blank line  
Invoke RPTREC to output a blank line  
Invoke GETREC to obtain a master file record  
While there are more input records:  
-Invoke FMTREC to format a detail line  
-Invoke RPTREC to output a detail line  
-Invoke GETREC to obtain the next masterfile record  
End While  
Invoke GETREC to close input file  
Invoke RPTREC to close report file  

**********************************************************************  

## Logger ## 
**Logger:** program to emit a message to LE message file on request

**Parameters:** 
- Null-terminated message (input)

**Processing:**
- Emit message parameter to DDname SYSOUT via CEEMOUT service

**Invocation example**
- call 'LOGGER' using z'FMT001 Bad parameter passed to FMTREC'

**Pseudo-code** 

Obtain input parameter (message ending with x'00', could be z' '-type literal)  
Populate LE message text parameter with parameter  
Populate LE message length parameter with size of message  
Invoke CEEMOUT to issue message  

**Error message processing (all modules)**
1) Error (or other) messages should be issued via calls to the LOGGER routine
2) Messages passed to LOGGER should be null-terminated strings (using the z'xxxx' format for a VALUE clause, or some other technique for placing a hexadecimal '00' at the end)
3) Error messages should begin with a unique six character identifier followed by a blank, followed by the message text
4) Messages may also be free format (i.e., not beginning with a six byte message ID, but still terminated by hexadecimal '00')

**CEEMOUT parameters** 
1) (Input) Text string, preceded by a binary halfword specifying the length of the string
2) (Input) Binary fullword, containing the value +2
3) (Output) PIC X(12) field - feedback code from CEEMOUT; usually ignored

**********************************************************************  

## GETREC ## 

**GETREC:** Program to retrieve a record from the input file. Program behavior depends on the value of the first parameter (Function Code) 
 
**Parameters** 
1) Function Code: PIC X(1) (input)
2) I/O area: 80 byte character field to contain record (output)   
-unused with function codes 1 and 9

**Processing** 
Function code 1: open the inventory file  
Function code 2: return the next record on the inventory master file 
Function code 9: close the inventory master file
Any other function code: issue a message via LOGGER, and terminate execution.

**Invocation example** 
call 'GETREC' using by content '2' by reference INAREA

**Pseudo-code** 
Obtain input parameter (function code)  
Case (function code):  
* when 1: open input file  
* when 2: optain next input record  
  * if end of file
     * return with 4 in return code conceptual data item
  * else 
     * place input record in I/O area output parameter 
     * return with 0 in return code conceptual data item
  * end if
* when 9: close input file
* when other:
  * issue message; terminate execution
* End Case

**********************************************************************  


## RPTREC ##

**RPTREC:** Program to output a record to a report. Program behavior depends on the value of the first parameter (Function Code)

**Parameter** 
1) Function Code: PIC X(1) (input) 
2) I/O area: 133 byte character field that contains record (input)
-Unused with function codes 1 and 9  

**Processing** 
* Function Code 1: open the output report file
* Function Code 2: write a record to the output report file
* Function Code 9: close the output report file
* Any other function code: issue a message via LOGGER, and terminate execution.

**Invocation example** 
call 'RPTREC' using by content '2' by reference OUTAREA

**Pseudo-code** 
Obtain input parameters (function code, I/O area)  
Case (function code):    
* When 1: open output file  
* When 2: write output record from I/O area parameter  
* When 9: close output file  
* When other: issue message; terminate execution 

End case

**********************************************************************  

## FMTREC ##

**FMTREC:** Program to format a report record from an input record

**Parameters**  
1) Function Code: PIC X(1) (input)
2) Input record: 80 byte character field that contains input record (unused with Function codes 2 & 3)
3) Output record: 133 byte character field that is populated with content determined by the function code

**Processing**  
* Function Code 1: Produces a report detail line containing the part number, description, unit price, quantity on hand, quantity on order, reorder level, and item category fields from the input record  
* Function Code 2: Produces a column header line with column labels that align with the fields in the detail line  
* Function Code 3: Produces a blank line, to be used for spacing  
* Any other function code: issue a message via LOGGER, and terminate execution.  

NOTE: The detail line and blank line should specify a blank in column 1 of the output, indicating single spacing. The column header line should specify a '0' in column 1, indicating double spacing.

**Invocation example**  
call 'FMTREC' using by content '2' by reference INAREA OUTAREA  

**Pseudo-Code**  
Obtain input parameters (function code, input I/O area)  
Case (function code):  
* when 1: populate output I/O area parameter with fields from input I/O area
* when 2: populate output I/O area parameter with column headers
* when 3: populate output I/O area parameter with all blanks
* when other: issue message; terminate execution  

End Case  

**********************************************************************  

## ENHANCEMENT 1 ##  
### Adding derived fields ###  

Include reorder flag and item value.
    * Reorder Flag: one byte flag containing either an asterick or a blank  
      Reorder flag should contain an asterick if, for the record, the quantity on hand plus the quantity on order is less than the reorder level
    * Item Value: the product of the quantity on hands times the unit price, rounded to two decimal places, and display the dollar value like:  
      $9,999,999.99, with $ adjacent to the first significan digit of the value


## ENHANCEMENT 2 ##  
### Adding Page Break Logic ###  

1) Improve the output report by adding logic to count lines, and start a new page after 40 detail lines. At the top of the new page, display the column header line from FMTREC and a blank line (also from FMTREC).  
2) Add a new line report. This will be a page header, containing a report title ("INVENTORY REPORT") and a page number. This line should precede the column header. The report title field should allow for a 40 byte title. The page number should be preceded on the line with the string "PAGE:".  
3) Add logic to maintain a page counter. The page number should start with one, and be incremented each time after a new page is displayed. The page counter should be displayed on the page header line.  
  
## ENHANCEMENT 3 ## 
### Adding Page Subtotals ###  
1) In FMTREC, add logic to accumulate the number of flagged records on a page. 
2) In FMTREC, add logic to accumulate the total of the item values on a page.  
3) In MAIN, add logic to display a page footer that shows the number of flagged records on a page and the total of the item values on a page. The footer line should include a text string indicating that it is a page subtotal line, and should include labels identifying the two fields. The page footer line should be preceded by a blank line ('0' for carriage control in column 1).  
4) After printing the page footer, reset the page accumulators to zero.  
  
## ENHANCEMENT 4 ##  
### Adding Grand Totals ###  
1) Add logic to accumulate the number of flagged records across the file. 
2) Add logic to accumulate the total of the item values accross the file. 
3) Add logic to display a grand total line at the end of the report that shows the number of flagged records on the entire file, and the total of the item values on the file. The grand total line should include a text string indicating that it is a grand total line, and should include labels identifying the two fields. The grand total line should be preceded by a blank line.

**********************************************************************  
**********************************************************************  
