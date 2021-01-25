
#include "inkey.ch"

PROC MAIN
local cInScreen   := savescreen(0,0,24,79)
local nSelect
slsf_color("S3COLOR")
initsup(.F.)
makebox(0,0,24,79,sls_normcol() )
WHILE .T.
   nSelect := MENU_V("Get samples:","Readers, Whens, valids",;
                     "Scrolling gets","Quit")
    DO CASE
    CASE nSelect = 1
       readers()
    CASE nSelect = 2
       showgetmany()
    otherwise
     exit
    ENDCASE
    makebox(0,0,24,79,sls_normcol() )
END
ss_rise(0,0,24,79,cInScreen)



//------------------------------------------------------------------
STATIC PROC READERS

local n
local lYesNo   := .f.
local lYesNo2  := .f.
local lNumber1 := 0
local cChar1 := space(15)
local cChar2 := space(15)
local cChar3 := space(10)
local cChar4 := space(15)
local lNumber2    := 0
local dDate       := date()
memvar getlist

@ 2,8 SAY "GET SYSTEM ENHANCEMENTS"

@ 4,9 SAY "...................(regular logical get)"
@ 5,9 SAY "...................YNREADER()   - popup Yes/No for logical fields"
@ 7,13 SAY "...............PMREADER()   - use +- keys for date/numeric fields"
@ 9,23 SAY ".....PICKREADER() - use a picklist for a get reader"
@ 11,23 SAY ".....SBREADER()   - use spacebar to toggle values from"
@ 12,43 SAY "an array"
@ 14,13 SAY "...............CALCWHEN()   - calculator as get WHEN clause"
@ 16,16 SAY "............CALENDWHEN() - calendar as get WHEN clause"
@ 18,23 SAY ".....SMALLVALID() - lookup table as get VALID clause"
@ 20,23 SAY ".....POPUPKSET()  - generic popup - F2 pops up ASCII"
@ 21,43 SAY "table"

POPUPKSET(K_F2,"READERS","cChar4",;
  {||iif( (n:=asciitable())#nil,getactive():insert(chr(n)):assign(),nil)})


@4,8 GET lYesno2   // filler
@5,8 get lYesNo send reader:= YNREADER()
@7,8 get lNumber1 pict "99999" send reader:= PMREADER()
@9,8 get cChar1 send reader:= PICKREADER({"TOM            ",;
                                               "DICK           ",;
                                               "HARRY          "})
@11,8 get cChar2 send reader := SBREADER({"WILMA          ",;
                                               "BETTY          ",;
                                               "ELVIRA!        "})

@14,8 get lNumber2 pict "99999" when CALCWHEN(.f.,.t.)
@16,8 get dDate    when CALENDWHEN(.f.,.t.)
@18,8 get cChar3 valid SMALLVALID({||!empty(cChar3)},"product",;
                           "Select Product","%S3PROD","PRODUCT"   )
@20,8 get cChar4
RAT_READ(getlist)
RETURN


//------------------------------------------------------------------

static proc showgetmany
 local i
 local aDesc := {"Get 1","Get 2","Get 3","Get 4","Get 5","Get 6","Get 7","Get 8",;
                 "Get 9","Get 10"}
 local aGets := {"Yo!",date(),time(),.t.,1234.56,"These","Are    ","scrolling",;
                 "Gets......",.t.}
 memvar getlist
 for i = 1 to len(aGets)
   @maxrow()+1,maxcol()+1 get aGets[i]
   aadd(aDesc,field(i))
 next
 SGETMANY(getlist,aDesc,7,10,15,60,"Editing - Multiple Scrolling Gets","ESC quits, F10 saves",1)
return
