//- This function returns the current drive. Formerly written in
//- assembler
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION CURD()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  CURD() Return current drive letter
ณ 
ณ  Returns:
ณ  --------
ณ  <cDrive> => drive letter
ณ 
ณ  Syntax:
ณ  -------
ณ  CURD()
ณ 
ณ  Description:
ณ  ------------
ณ  Returns the current drive letter, less colon (:).
ณ 
ณ  Examples:
ณ  ---------
ณ   ?"Current drive is ",CURD(),":"
ณ 
ณ  Source:
ณ  -------
ณ  CURD.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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

