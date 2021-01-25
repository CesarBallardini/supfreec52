/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION DELREC()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  DELREC() Dialog box to delete/undelete current record
ณ 
ณ  Returns:
ณ  --------
ณ  <nStatus> => If deleted 1, if undeleted-1, if no
ณ  action 0
ณ 
ณ  Syntax:
ณ  -------
ณ  DELREC()
ณ 
ณ  Description:
ณ  ------------
ณ  Asks for delete/undelete record with menu prompt and
ณ  then deletes/undeletes or not If current record is not deleted,
ณ  prompt will be
ณ 
ณ       DELETE  NOACTION
ณ 
ณ  If current record is deleted, prompt will be
ณ 
ณ       UNDELETE  NOACTION
ณ 
ณ  Examples:
ณ  ---------
ณ   IF nChoice = 6
ณ       nDelstat := DELREC()
ณ   ENDIF
ณ 
ณ  Source:
ณ  -------
ณ  S_DELET.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION delrec
local cMessage,nSelection,lYesOrNo,cUnderScreen,nOldCursor
local nReturn := 0
local aActions

IF Used()

   *- set cursor off
   nOldCursor      := setcursor(0)

   *-draw the box
   cUnderScreen    :=makebox(12,25,14,55,sls_popcol())

   *- determine the message/prompt and prompt it
   nSelection      := 1
   cMessage        := IIF(DELE(),"Un-Delete Record","Delete Record")


   aActions := {{13,27,cMessage},{13,45,"No Action"}}
   nSelection := rat_menu2(aActions)

   *- figure out what to do, based on the user's request
   lYesOrNo := (nSelection == 1)
   if SREC_LOCK(5,.T.,"Network error - Unable to lock record. Keep trying?")
     IF lYesOrNo
       IF DELE()
         RECALL
         nReturn := -1
       ELSE
         DELETE
         nReturn := 1
       ENDIF
       unlock
       goto recno()
   endif
   ELSE
     nReturn := 0
   ENDIF
   unbox(cUnderScreen)
   *- set cursor to prior
   setcursor(nOldCursor)
endif
RETURN nReturn

