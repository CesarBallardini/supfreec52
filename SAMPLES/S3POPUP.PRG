
PROC MAIN
local cMainScreen := savescreen(0,0,24,79)
local cSuper, cInScreen
local nChoice := 1
local aOptions,aSelect

slsf_color("S3COLOR")
initsup(.F.)
if iscolor()
  setblink(.f.)
endif
SETCOLOR(SLS_NORMCOL())
SET WRAP ON

cSuper  := "S"+chr(15)+"u"+chr(31)+"p"+chr(47)+"e"+chr(63)+"r"+chr(79)+"L"+chr(95)+"i"+chr(111)+"b"+chr(127)+"!"+chr(11)
cSuper  := left(repl(cSuper,223),4000)
SS_RISE(0,0,24,79,cSuper)
cSuper  := "P"+chr(9)+"o"+chr(9)+"p"+chr(9)+"u"+chr(9)+"p"+chr(9)+"s"+chr(9)+" "+chr(9)+"e"+chr(9)+"t"+chr(9)+"c"+chr(9)+"."+chr(9)
cSuper  := left(repl(cSuper,96),2112)
dispbox(3,3,22,72,space(9))
SS_FADE(5,5,20,70,cSuper)
cInScreen := savescreen(5,5,20,70)

aOptions := makeoptions()
aSelect  := a2tosing(aOptions,1)

if checkdbfs()
  do while .t.
      dispbox(5,24,20,51,space(9))
      scroll(6,25,19,50,0)

      nChoice := SACHOICE(6,25,19,50,aSelect,nil,nChoice)

      if nChoice = len(aOptions) .or. nChoice == 0
           exit
      else
           eval(aOptions[nChoice,2])
      endif
  enddo
endif
ss_implode(0,0,24,79,cMainScreen)


static function makeoptions
local aOptions := {;
     {"AMSG()       ",{||amsg({"This is a message","passed as an array",;
                               "which can contain","Character, numeric",;
                               "or date style ","elements",date(),diskspace();
                                })} },;
     {"ASCIITABLE() ",{||ASCIITABLE()} },;
     {"DELREC()     ",{||DELREC()} },;
     {"EDITMEMO()   ",{||MSG("About to edit the memo field MEMO"),;
                         EDITMEMO("MEMO")} },;
     {"EDITMEMOV()  ",{||MSG("About to edit the PRG file S3POPUP.PRG"),;
                         EDITMEMOV(MEMOREAD("S3POPUP.PRG"))} },;
     {"GETCALC()    ",{||GETCALC()} },;
     {"GETDATE()    ",{||GETDATE()} },;
     {"HARDCOPY()   ",{||HARDCOPY()} },;
     {"MCHOICE()    ",{||MCHOICE(afieldsx(),nil,nil,nil,nil,"Pick a Field")} },;
     {"MESSYN()     ",{||MESSYN("Is this what you're looking for?")} },;
     {"MFIELDS()    ",{||mfields("Select a field")} },;
     {"MFIELDSTYPE()",{||mfieldstype("C","Select a NUMERIC field")} },;
     {"MULTIMSGYN() ",{||multimsgyn({"Would you like","to make","a selection?"},;
                         "OK","Cancel")} },;
     {"POPCOLSEL()  ",{||popcolsel()} },;
     {"POPEX()      ",{||POPEX("*.PRG")} },;
     {"POPUPDIR()   ",{||POPUPDIR(NIL,NIL,NIL,NIL,.T.)} },;
     {"SPOPORDER()  ",{||SPOPORDER()} },;
     {"SPOPSEEK()   ",{||SPOPSEEK(),VERTVIEW()} },;
     {"STAGFIELDS() ",{||STAGFIELDS(nil,"Tag Fields")} },;
     {"TAGARRAY()   ",{||TAGARRAY(A2TOSING(DIRECTORY(),1))} },;
     {"TAGMARRAY()  ",{||TAGMARRAY(DIRECTORY())} },;
     {"VERTVIEW()   ",{||VERTVIEW()} },;
     {"VIEWMEMOS()   ",{||VIEWMEMOS()} },;
     {"SATTPICK()   ",{||SATTPICK()} },;
     {"Quit          ",{||nil} };
     }

return aOptions


static function checkdbfs
local ldbfsOK := .f.
if !( file("s3sample.dbf") .and. file("s3sample.dbt") )
  msg("Missing files - S3SAMPLE.DB*")
elseif SNET_USE("s3sample","s3sample",.f.,5,.t.,"Unable to open S3SAMPLE. Try again?")
  ldbfsOK := .t.
  if !( file("s3samp1.ntx") .and. file("s3samp2.ntx") )
     ProgIndex("S3SAMP1","LNAME",.f.,.t.,.f.)
     ProgIndex("S3SAMP2","ZIP",.f.,.t.,.f.)
     set index to s3samp1,s3samp2
  else
    set index to s3samp1,s3samp2
  endif
endif
return ldbfsOk


