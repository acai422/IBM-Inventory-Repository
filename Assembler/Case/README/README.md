# IBM Assembler Case Study  
## Purpose: A Case Study developed by Hunter Cobb from IBM to test our Assembler knowledge  
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

Logical Record Length:100  
DDNAME: INFILE  
DSNAME: INSTN03.CASE.INPUTA  

## Report File Record Layout
Report will be a columnar style report, written as a SYSOUT-type file, viewable via SDSF  
There will be multiple output record types; content specified in the module specifications.  

DDNAME: OUTFILE

## Design Overview

The program is to consist of several separately coded modules, to facilitate code reuse and to enable easier modifications. The modules should be coded and tested, first individually, and then together.

QSAM I/O should be used for all file accesses.

A debugging assistance module - SNAPPER - should be one of the first modules coded. SNAPPER issues a SNAP dump of a specified storage area.  
Standard operating system linkage should be used for inter-program communication (except for SNAPPER).

Initially there should be five program modules:
1) MAIN: Main program to drive the overall program logic
2) GETREC: Subroutine to provide MAIN with records from the input file. All references to the input file should be contained in GETREC
3) FMTREC: Subroutine to format a report record, based on a record from the input file
4) RPTREC: Subroutine to output a record to a report file (which will be a SYSOUT-type file in the execution JCL). All references to the report file should be contained in the RPTREC.
5) SNAPPER: Subroutine to invoke a SNAP macro to display an area of memory, to facilitate debugging.

# INITIAL PSEUDO-CODE

**MAIN PROGRAM**


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
Standard assembler program exit; return code zero.  
   
Invocation of external subroutines should be done from within internal modules branched to via BAS. These internal modules should check for error returns from the external subroutine, and, if an error occurs, should issue a message via WTO, and exit the program with a return of 4.
**********************************************************************  

**SNAPPER**  
Standard assembler program entry  
Obtain input parameters(memory start location, memory length, dump ID)  
If SNAP DCB is not open:    
-open snap DCB
-If open not successful, abend  
-End if  
End if  
Issue SNAP macro to produce memory dump based on input parameters  
Standard assembler program exit  
**********************************************************************
  
**GETREC**  
Standard assembler program entry  
Obtain input parameter(function code, I/O area)  
Case(function code):  
* when 1:
  * open input file
  * if open error:
    * issue message
    * return with 8 in register 15
  * end if
* when 2:
  * obtain next input record
  * if end of file:
    * return with 4 in register 15
  * else
    * place input record in the I/O area parameter
    * return with 0 in register 15
  * end if
* when 99:
  * close input file
  * if close error:
    * issue message
    * return with 8 in register 15
  * end if
* when other:
  * issue message
  * return with 8 in register 15  
  
End Case  
Standard assembler program exit
**********************************************************************
**RPTREC**  
Standard assembler program entry  
Obtain input parameters(function code, I/O area)  
Case(function code):  
* when 1:
  * open output file
  * if open error:
    * issue message
    * return with 8 in register 15
  * end if
* when 2:
  * write output record from I/O area parameter
  * return with 0 in register 15
* when 99:
  * close output file
  * if close error:
    * issue message
    * return with 8 in register 15
  * end if
* when other:
  * issue message
  * return with 8 in register 15  
  
End Case  
Standard assembler progam exit  
************************************************************************  
**FMTREC**  
Standard assembler program entry  
Obtain input parameters(function code, input I/O area, output I/O area)  
Case(function code):
* when 1:
  * populate output I/O area with fields from input I/O area  
* when 2:
  * populate output I/O area with column header corresponding to fields specified for option 1
* when 3
  * populate output I/O with all blanks
* when other:
  * issue message
  * return with 8 in register 15  
  
End Case  
Standard assembler program exit  
***************************************************************************  
## Module Specifications ##

**MAIN:** Program to produce inventory report:  
* Parameters: none (invoked from JCL)
* Calls: GETREC, RPTREC, FMTREC
* Return codes (register 15):
  * 0 - Successful report written
  * 4 - Some error occured
* Input: INPUTA file (DDNAME: INFILE)
* Outputs:
  1) Report file (DDNAME: OUTFILE)
  2) Messages via WTO Macro
* Processing:
  * MAIN should read through the records of the input master file, producing one detail line for each record on the input file. Before the first detail line, there should be a column header file and a blank line.  
  * If a subroutine returns an error indication, MAIN should produce a message in the JCL indicating that an error has occured and terminating with a return error of 4. This message should be produced with a WTO macro, with a ROUTCDE of 11.
  * Main should produce a (non-error) message at the beginning of execution, saying that the program was entered, and another (non-error) message at the end of execution, saying that the program was finished.    
  
**SNAPPER:** program to produce a SNAP dump of memory on request:  
* Parameters (all input):
  1) Address at which memory dump is to begin: binary fullword
  2) Number of bytes to dump: binary halfword
  3) Dump ID to pass to SNAP to identify the dump: binary halfword  
* Proccessing:
  1) On first invocation, open the DCB for the SNAP macro to use for output - DDNAME SNAPDUMP (abend if OPEN fails)  
  2) On every invocation, issue a SNAP macro, specifying the display of memory starting at the address indicated by the first parameter, for as many bytes as the second parameter specifies. Identify the SNAP dump with the value provided by the third parameter.  
* Return code in register 15: zero  
* Special Considerations:  
SNAPPER should use a non-standard parameter convention; register 1 should point to an eight byte location in memory, containing the starting dump address (four bytes), the number of bytes to dump (two bytes), and the dump ID (two bytes)  
  
**GETREC:** program to retrieve a record from the input file. Program behavior depends on the value of the first depends on the value of the first parameter(Function Code)  
  
Parameters:  
1) Funtion Code: binary fullword (input)
  * 1 - Open input file
  * 2 - Obtain next record  
  * 99 - Close input file  
2) I/O area: 100 byte character field to contain record (output) Unused with function codes 1 and 99.  
  
Return code in register 15:  
* 0 - Successful request
* 4 - End of File  
* 8 - Parameter error or open/close error
  
Proccessing:  
* For function code of 1, GETREC should open the inventory master file.
* For function code of 2, GETREC should read the next record on the inventory master file, and place the recored in the I/O area parameter. If the read encoounters an endo of file, GETREC should return a 4 in register 15. 
* For a function code of 99, GETREC should close the inventory master file.  
* For any other function code, or in the event of an open or close error, GETREC should issue a message via WTO indicating the tye of error, and return an 8 in register 15.  
  
**RPTREC:** program to output a record to a report. Program behavior depends on the value of the first parameter (Function Code).  
  
Parameters:  
1) Function Code: binary fullword (input)
   * 1 - Open output file  
   * 2 - Write output record
   * 99 - Close output file  
2) I/O area: 133 byte character field that contains record (input). Unused with function fodes 1 and 99.  
  
Return code (register 15):  
* 0 - Successful request
* 8 - Parameter error or open/close error  
  
Processing:  
* For a function code of 1, RPTREC should open the output report file.  
* For a function code of 2, RPTREC should write the next record on the inventory master file, and replace the record in the I/O area parameter.  
* For a function code of 99, RPTREC should close the output report file.  
* For any other function code, or in the event of an open error or close error, RPTREC should issue a message via WTO indicating the type of error, and return an 8 in register 15.  
  
**FMTREC:** program to format a report record from an input record.  
  
Parameters:  
1. Function Code: binary fullword (input)  
* 1 - Format a detail line  
* 2 - Format a column header line  
* 3 - Format a blank line  
2. Input record: 100 byte character field that contains input record (unused with function codes 2 & 3)  
3. Output line: 133 byte character field that is populated with content determined by the funtion code.  
  
Return code (register 15):  
0 - Successful request  
8 - Parameter error  
  
Processing:  
* For a function code of 1, FMTREC produces a report detail containing the part number (9 byte character field) and description (30 byte character field) from the input record.
  * EXTENTION 1: include all information (i.e. part number, description, unit price, ect.) except old part number
  * EXTENTION 2: include reorder flag and item value.
    * Reorder Flag: one byte flag containing either an asterick or a blank  
      Reorder flag should contain an asterick if, for the record, the quantity on hand plus the quantity on order is less than the reorder level
    * Item Value: the product of the quantity on hands times the unit price, rounded to two decimal places, and display the dollar value like:  
      $9,999,999.99, with $ adjacent to the first significan digit of the value
  * A separate program, CALCFLDS will be needed. CALCFLDS takes in 3 parameters, Input Record, Output Flag, and Output Item Value. 
    * Input Record: 100 byte character field that contains input record
    * Output Flag: One byte field containing:
      1) '*' if quantity on hand + quantity on order is less than reorder level.
      2) Blank otherwise.
    * Output Item Value: packed decimal (nine digits, two implied decimal places, calculated as quantity on hand times unit price, rounded to two decimal places.
    
* For a function code of 2, FMTREC produces a column header line with column labels that align with the fields in the detail line.  
* For a function code of 3, FMTREC produces a blank line, to be used for spacing.  
* In all these cases, FMTREC returns a zero in register 15.  
* For any other function code, FMTREC leaves the output line unchanged, and returns an 8 in register 15.  
