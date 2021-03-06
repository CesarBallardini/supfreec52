//- This function returns the current drive. Formerly written in
//- assembler
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION CURD()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  CURD() Return current drive letter
³ 
³  Returns:
³  --------
³  <cDrive> => drive letter
³ 
³  Syntax:
³  -------
³  CURD()
³ 
³  Description:
³  ------------
³  Returns the current drive letter, less colon (:).
³ 
³  Examples:
³  ---------
³   ?"Current drive is ",CURD(),":"
³ 
³  Source:
³  -------
³  CURD.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION curd
local cTempfile := UNIQFNAME("___")   // create a temporary file name
local cDrive
local cCommand  := "cd > "+cTempFile  // send the CD command to the
                                      // temporary file
set console off                       // don't want to see the output
!(cCommand)                           // do the command
set console on
cDrive := left(memoread(cTempFile),1) // read the file in and parse the
                                      // drive name from it
erase (cTempFile)                     // erase the file
return cDrive

