/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION DELREC()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  DELREC() Dialog box to delete/undelete current record
³ 
³  Returns:
³  --------
³  <nStatus> => If deleted 1, if undeleted-1, if no
³  action 0
³ 
³  Syntax:
³  -------
³  DELREC()
³ 
³  Description:
³  ------------
³  Asks for delete/undelete record with menu prompt and
³  then deletes/undeletes or not If current record is not deleted,
³  prompt will be
³ 
³       DELETE  NOACTION
³ 
³  If current record is deleted, prompt will be
³ 
³       UNDELETE  NOACTION
³ 
³  Examples:
³  ---------
³   IF nChoice = 6
³       nDelstat := DELREC()
³   ENDIF
³ 
³  Source:
³  -------
³  S_DELET.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

