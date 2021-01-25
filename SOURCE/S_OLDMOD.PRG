#define MOD_ADD      1
#define MOD_EDIT     2
#define MOD_DELETE   3
#define MOD_SEEALSO  4
#define MOD_CONT     5
FUNCTION OLD_MOD
local cKey, cText, cPretext, aAlsos, nAlso, cAlso, i, nRecord, nContent
local aContents, aTags, cErrors, nCount, cScreen, nModify, cContents
local lchange := .f.
nModify := MCHOICE({"Add Topic","Edit Topic",;
                   "Delete Topic","Modify SEEALSOs",;
                   "Generate CONTENTS record","Cancel"})
do case
case nModify == MOD_ADD
  cKey := space(35)
  POPREAD(.T.,"KEY for new Topic",@cKey,"@!")
  if alltrim(cKey)=="CONTENTS"
    msg("CONTENTS is a reserved KEY")
  elseif !empty(cKey)
    cText := ""
    cScreen := savescreen(0,0,24,79)
    dispbox(0,0,24,79,repl("±",9))
    cText := EDITMEMOV(cText,3,1,21,78,.T.,73,"Enter text for TOPIC")
    restscreen(0,0,24,79,cScreen)
    if !empty(cText) .or. ;
          ( empty(cText).and.messyn("Topic empty. Save anyways?") )
       locate for empty(field->TOPIC)
       if !found()
               APPEND BLANK
       endif
       IF SREC_LOCK(5,.T.,"Unable to lock record. Try again?")
         replace field->text with cText, field->topic with cKey
         lChange := .t.
       ENDIF
    endif
  endif
case nModify == MOD_EDIT
    ctext := FIELDGET(FIELDPOS("text"))
    cPretext := ctext
    cScreen := savescreen(0,0,24,79)
    dispbox(0,0,24,79,repl("±",9))
    ctext := EDITMEMOV(ctext,3,1,21,78,.T.,73,"Enter text for TOPIC")
    restscreen(0,0,24,79,cScreen)
    if !(ctext==cPretext)
      IF SREC_LOCK(5,.T.,"Unable to lock record. Try again?")
        replace field->text with ctext
        lChange := .t.
        UNLOCK
      ENDIF
    endif
case nModify == MOD_DELETE
    if !messyn("Delete?","No","Yes")
      IF BLANKREC()
          seek "CONTENTS"
          if !found()
            locate for !empty(field->TOPIC)
          endif
          lchange := .t.
      endif
    endif
case nModify == MOD_SEEALSO
   nRecord := recno()
   aAlsos := {}
   if !empty(field->keys)
       for i = 1 to mlcount(field->keys,80)
          if !empty(cAlso := alltrim(memoline(field->keys,80,i)) )
            aadd(aAlsos,cAlso)
          endif
       next
   endif
   while .t.
     go (nRecord)
     nModify := MCHOICE({"View SEEALSOs","Add SEEALSO","Delete SEEALSO","Quit"})
     do case
     case nModify == 1
        if len(aAlsos)>0
          mchoice(aAlsos)
        else
          msg("None currently specified")
        endif
     case nModify == 2
         cAlso := ""
         go top
         Smalls({||field->topic},"Current Keys",nil,{||cAlso := field->topic } )
         if !empty(cAlso)
           AADD(aAlsos,cAlso)
         endif

     case nModify == 3
        if (nAlso := mchoice(aAlsos)) > 0
           if messyn("Delete:"+aAlsos[nAlso])
             adel(aAlsos,nAlso)
             ASIZE(aAlsos,len(aAlsos)-1)
           endif
        endif
     case nModify == 4 .or. nModify==0
       exit
     endcase
   end
   cAlso := ""
   for i = 1 to len(aAlsos)
     cAlso += aAlsos[i]+chr(13)+chr(10)
   next
  IF SREC_LOCK(5,.T.,"Unable to lock record. Try again?")
    replace field->keys with cAlso
    UNLOCK
  ENDIF

case nModify == MOD_CONT
  IF MESSYN("Create a new CONTENTS record?")
     aContents := {}
     nContent := MCHOICE({"Generate CONTENTS record from ALL topics",;
                          "TAG topics to be included in CONTENTS record",;
                          "Cancel"})
     do case
     case nContent == 1
           for i = 1 to recc()
              go (i)
              if !empty(field->topic) .and. !alltrim(field->topic)=="CONTENTS"
                      AADD(aContents,field->TOPIC)
                      aContents := ASORT(aContents)
              endif
           next
           aContents := ASORT(aContents)
     case nContent == 2
           aTags := tagit(nil,nil,nil,"Tag TOPICS for CONTENTS record")
           for i = 1 to len(aTags)
              go (aTags[i])
              AADD(aContents,field->TOPIC)
           next
           aContents := ASORT(aContents)
     otherwise
     endcase
     if len(aContents)>0
        cContents := ""
        for i = 1 to len(aContents)
           cContents += aContents[i]+chr(13)+chr(10)
        next
        lChange := .t.
        seek "CONTENTS"
        if found() .and. SREC_LOCK(5,.T.,"Unable to lock record. Try again?")
           replace FIELD->text with cContents
           unlock
        else
           locate for empty(field->topic)
           if !found()
                   APPEND BLANK
           endif
           replace field->topic with "CONTENTS"
           replace field->text with cContents
        endif
     endif
  ENDIF

endcase

return lChange


