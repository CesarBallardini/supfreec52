#define REC_TAGGED 1
#define REC_QUERY  2
#define REC_ALL    3

#define FWORDPERFECT42  1
#define FWORDPERFECT50  2
#define FMSWORD         3
#define FMSWORD50       4

//-----------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SMAILMERGE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SMAILMERGE() Creates mailmerge files for WordPerfect & MS Word
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SMAILMERGE([<aFields>,<aDesc>,<aTypes>,<aLens>,<aDeci>])
ณ 
ณ  Description:
ณ  ------------
ณ  This is a menu driven metafunction for creating
ณ  mailmerge files for WordPerfect and MS Word. Merge files can be created
ณ  with selected fields and for selected conditions.
ณ 
ณ  [<aFields>,<aDesc>,<aTypes>,<aLens>,<aDeci>] are
ณ  optional arrays of fieldnames, field descriptions, field types,
ณ  field lengths, field decimals. Pass all or none. Default is all
ณ  fields.
ณ 
ณ  Examples:
ณ  ---------
ณ   use CUSTOMER
ณ 
ณ   SMAILMERGE()
ณ 
ณ  Source:
ณ  -------
ณ  S_MAILM.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function smailmerge(aFieldNames,aFieldDesc,aFieldTypes,aFieldLens,aFieldDeci)
local nRecordSele := 3
local nFormat     := 0
local aTagged     := {}
local aFieldsPicked
local aPickedNames := {}
local aPickedBlocks:= {}
local i
local bQuery := {||.t.}
LOCAL nOldCursor     := setcursor(0)
LOCAL cInScreen      := Savescreen(0,0,24,79)
LOCAL cOldColor      := Setcolor(sls_normcol())
local nMenuChoice
local nMouseR, nMouseC

if valtype(aFieldNames)+valtype(aFieldDesc)+valtype(aFieldtypes)+;
   valtype(aFieldLens)+valtype(aFieldDeci)<>"AAAAA"
  aFieldNames := array(fcount())
  aFieldDesc  := array(fcount())
  aFieldTypes := array(fcount())
  aFieldLens  := array(fcount())
  aFieldDeci  := array(fcount())
  afields(aFieldNames)
  afields(aFieldDesc)
  fillarr(aFieldNames,aFieldTypes,aFieldLens,aFieldDeci)
endif

*- draw boxes
@0,0,24,79 BOX sls_frame()
Setcolor(sls_popcol())
@1,1,8,40 BOX sls_frame()
@1,5 SAY '[MailMerge Creation]'
@18,1,23,78 BOX sls_frame()
@19,2 SAY "Create merge type :"
@20,2 SAY "Filter type       :"
@21,2 SAY "Fields selected   :"

DO WHILE .T.
  @19,25 SAY   padr({"",;
                     "Wordperfect 4.2     ",;
                     "Wordperfect 5.0 +   ",;
                     "Microsoft Word (before 5.0)",;
                     "Microsoft Word 5.0 +" }[nFormat+1],40)
  @20,25 SAY   padr({"Tagged Records",;
                     "Records meeting Query",;
                     "All records"}[nRecordSele],40)
  @21,25 say alltrim(str(len(aPickedBlocks)))+" fields selected      "
  Setcolor(sls_popmenu())
  nMenuChoice := RAT_MENU2({;
              {2,3,"Merge Type"},;
              {3,3,"Which Fields"},;
              {4,3,"Filter"},;
              {5,3,"Create Merge File"},;
              {6,3,"Quit"}},nMenuChoice,.t.)

  Setcolor(sls_popcol())

  DO CASE
  CASE nMenuChoice = 1
      nFormat := menu_v("[Mailmerge Format]",;
                        "A  Wordperfect 4.2     ",;
                        "B  Wordperfect 5.0 +   ",;
                        "C  Microsoft Word (before 5.0)",;
                        "D  Microsoft Word 5.0 + ",;
                        "Quit")
      nFormat := iif(nFormat==5,0,nFormat)
  CASE nMenuChoice = 2
      aPickedBlocks := {}
      aPickedNames := {}
      aFieldsPicked := tagarray(aFieldDesc,"Select Fields")
      if len(aFieldsPicked)>0
       for i = 1 to len(aFieldsPicked)
          if aFieldTypes[aFieldsPicked[i]]<>"M"
            if aFieldTypes[aFieldsPicked[i]]=="C" .and. messyn("Trim "+aFieldDesc[aFieldsPicked[i]])
              aadd(aPickedBlocks,&("{||trim("+aFieldNames[aFieldsPicked[i]]+")}") )
              aadd(aPickedNames,aFieldDesc[aFieldsPicked[i]])
            else
              aadd(aPickedBlocks,&("{||trans("+aFieldNames[aFieldsPicked[i]]+",'')}") )
              aadd(aPickedNames,aFieldDesc[aFieldsPicked[i]])
            endif
          endif
       next
      endif
  CASE nMenuChoice = 3
      nRecordSele := menu_v("[Write Mailmerge Files from:]",;
                             "Tagged Records","Records meeting Query",;
                             "All Records","Quit")
      nRecordSel := iif(nRecordSel>3 .or. nRecordSel<=0 ,3,nRecordSel)
      do case
      case nRecordSele = REC_TAGGED
         tagit(aTagged,aFieldNames,aFieldDesc,"Merge Records")
         if len(aTagged)>0
           bQuery := {||ascan(aTagged,recno())>0}
         endif
      case nRecordSele = REC_ALL
         bQuery := {||.t.}
      case nRecordSele = REC_QUERY
         query(aFieldNames,aFieldDesc,aFieldtypes," to Merge",.t.)
         if !empty(sls_query())
           bQuery := sls_bquery()
         else
           bQuery := {||.t.}
         endif
      endcase
  CASE nMenuChoice = 4 .and. len(aPickedNames)>0 .and. nFormat >0
      writemerge(bQuery,nFormat,aPickedNames,aPickedBlocks)
  CASE nMenuChoice = 4 .and. len(aPickedNames)=0
      msg("Select fields first")
  CASE nMenuChoice = 4 .and. nFormat =0
      msg("Select format first")
  CASE nMenuChoice = 5
      exit
  ENDCASE
END
Restscreen(0,0,24,79,cInScreen)
Setcolor(cOldColor)
setcursor(nOldCursor)
return nil
//-----------------------------------------------------------------

static function writemerge(bQuery,nFormat,aPickedNames,aPickedBlocks)
local cOutfile,nOuthandle,i,cBox
local nCopied := 0

cOutFile := space(12)
popread(.t.,"Name of mailmerge file to create ",@cOutFile,"")
if empty(cOutFile)
   return .f.
endif
nOutHandle := fcreate(cOutFile)
if nOutHandle < 0
   msg("Unable to create mailmerge file")
   return .f.
endif
go top
plswait(.t.,"Looking...")
locate for eval(bQuery)
plswait(.f.)
if !found()
    fclose(nOutHandle)
    msg("No matching Records found")
    return .f.
endif

cBox = MAKEBOX(6,15,14,70,sls_popcol())
@ 9,15 SAY 'ร'
@ 9,70 SAY 'ด'
@ 9,16 TO 9,69
@ 7,20 SAY "Copying Records"
@ 8,20 SAY "from "+alias()+" into "

do case
case nFormat = FWORDPERFECT42
        ??"Wordperfect 4.2 mergefile"
case nFormat = FWORDPERFECT50
        ??"Wordperfect 5.0 + mergefile"
case nFormat = FMSWORD
        ??"Microsoft Word mergefile < 5.0"
        for i = 1 to len(aPickedNames)-1
                fwrite(nOutHandle,chr(34)+aPickedNames[i]+chr(34)+",")
        next
        fwrite(nOutHandle,chr(34)+atail(aPickedNames)+chr(34)+chr(13)+chr(10))
case nFormat = FMSWORD50
        ??"Microsoft Word mergefile 5.0 +"
        for i = 1 to len(aPickedNames)-1
                fwrite(nOutHandle,aPickedNames[i]+",")
        next
        fwrite(nOutHandle,atail(aPickedNames)+chr(13)+chr(10))
endcase
@ 11,20 SAY "0 Records copied"

while found()
   do case
   case nFormat = FWORDPERFECT42
      for i = 1 to len(aPickedBlocks)
              fwrite(nOutHandle,alltrim(eval(aPickedBlocks[i]))+chr(18)+chr(10))
      next
      fwrite(nOutHandle,chr(5)+chr(10))
   case nFormat = FWORDPERFECT50
      for i = 1 to len(aPickedBlocks)
              fwrite(nOutHandle,alltrim(eval(aPickedBlocks[i]))+chr(18)+chr(13))
      next
      fwrite(nOutHandle,chr(5)+chr(12))
   case nFormat = FMSWORD
      for i = 1 to len(aPickedBlocks)-1
              fwrite(nOutHandle,chr(34)+alltrim(eval(aPickedBlocks[i]))+chr(34)+",")
      next
      fwrite(nOutHandle,chr(34)+alltrim(eval(atail(aPickedBlocks)))+chr(34)+chr(13)+chr(10))
   case nFormat = FMSWORD50
      for i = 1 to len(aPickedBlocks)-1
              fwrite(nOutHandle,alltrim(eval(aPickedBlocks[i]))+",")
      next
      fwrite(nOutHandle,alltrim(eval(atail(aPickedBlocks)))+chr(13)+chr(10))
   endcase
   nCopied++
   @ 11,20 SAY alltrim(str(nCopied))
   ??" Records copied"
   continue
end
fclose(nOutHandle)
@13,20 say "Process complete! Press a key"
rat_event(20)
unbox(cBox)
return .t.



