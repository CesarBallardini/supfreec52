
proc main
local cMainScreen := savescreen(0,0,24,79)
local cSuper, cInScreen
local nChoice := 1
local aOptions,aSelect

use s3sample

slsf_color("S3COLOR")
initsup(.F.)
if iscolor()
  setblink(.f.)
endif
SETCOLOR(SLS_NORMCOL())
SET WRAP ON
dispbegin()
cSuper  := "S"+chr(15)+"u"+chr(31)+"p"+chr(47)+"e"+chr(63)+"r"+chr(79)+"L"+chr(95)+"i"+chr(111)+"b"+chr(127)+"!"+chr(11)
cSuper  := left(repl(cSuper,223),4000)
restscreen(0,0,24,79,cSuper)
cSuper  := "P"+chr(9)+"r"+chr(9)+"o"+chr(9)+"g"+chr(9)+"r"+chr(9)+"e"+chr(9)+"s"+chr(9)+"s"+chr(9)+"B"+chr(9)+"a"+chr(9)+"r"+chr(9)
cSuper  := left(repl(cSuper,96),2112)
dispbox(3,3,22,72,space(9))
restscreen(5,5,20,70,cSuper)
cInScreen := savescreen(5,5,20,70)
dispend()

aOptions := {;
            {"Index Progress - PROGINDEX()",{||indices()} },;
            {"Count Progress - PROGCOUNT()",{||counter()} },;
            {"Loop  Progress - PROGON(),PROGDISP(),PROGOFF() ",{||looper()} },;
            {"Copy  Progress - PROGON(),PROGDISP(),PROGOFF() ",{||copycount()} },;
            {"Quit",nil};
            }
aSelect  := a2tosing(aOptions,1)

do while .t.

    nChoice := MCHOICE(aSelect)

    if nChoice = len(aOptions) .or. nChoice == 0
         exit
    else
         eval(aOptions[nChoice,2])
    endif
enddo
ss_implode(0,0,24,79,cMainScreen)



//-------------------------------------------------------------
static proc copycount
local nCounted := 0
local nMatches := 0
local bDisplay := {||alltrim(str(nMatches))+" copied of "+alltrim(str(recc()))+" with "+alltrim(str(recc()-nCounted))+" to check" }
field lname
dbgotop()
ProgOn("Copying where LNAME contains S")
copy to ERASEME.DBF for "S"$LNAME.and.(nMatches++,.t.) while ;
          (nCounted++,ProgDisp(nCounted,recc(),bDisplay ))
@ 17,9 SAY "Done - press a key"
rat_event(0)
ProgOff()
return

//-------------------------------------------------------------
static proc looper
 local i
 msg("This just counts from 1 to 1000, displaying progress",;
      "Press ESCAPE to cancel it")
 ProgOn("Test")
 for i = 1 to 1000
   IF !ProgDisp(i,1000,{||alltrim(str(i))+" of 1000"},{||inkey()#27} )
     exit
   endif
 next
 @ 17,9 SAY "Done - press a key"
 rat_event(0)
 ProgOff()

return

//-------------------------------------------------------------
static proc counter
field lname
ProgCount({||"S"$LNAME.or."s"$LNAME},"Counting for S in LNAME",.t.)
return


//-------------------------------------------------------------
static proc indices
ProgIndex("S3SAMP1","LNAME",.f.,.t.,.f.)
ProgIndex("S3SAMP2","ZIP",.f.,.t.,.f.)
set index to s3samp1,s3samp2
return


