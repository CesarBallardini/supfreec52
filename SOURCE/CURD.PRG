//- This function returns the current drive. Formerly written in
//- assembler
/*
�����������������������������������������������������������������
� FUNCTION CURD()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  CURD() Return current drive letter
� 
�  Returns:
�  --------
�  <cDrive> => drive letter
� 
�  Syntax:
�  -------
�  CURD()
� 
�  Description:
�  ------------
�  Returns the current drive letter, less colon (:).
� 
�  Examples:
�  ---------
�   ?"Current drive is ",CURD(),":"
� 
�  Source:
�  -------
�  CURD.PRG
� 
����������������������������������������������������������������� 
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
