#INCLUDE "INKEY.CH"

proc main
local nChoice
slsf_color("S3COLOR")
initsup()
setcolor(sls_normcol())

while .t.
    nChoice := menu_v("Lookups:","In GETS","With Exception Block","Quit")
    do case
    case nChoice == 1
      LOOKREAD()
    case nChoice == 2
      LOOKEXCEPT()
    case nChoice == 3
      exit
    endcase
end


//--------------------------------------------------------------------------
static proc lookexcept
local bBlock := {|k|iif(k==K_ALT_E .or. k==K_ALT_A,GENED(k==K_ALT_A),nil)}
field product
aMsg({ "What we'll do here","is set up a call to SMALLS()", "which contains an",;
       "exception block which calls GENED()","so that if ALT-A is pressed, a",;
       "record is added","and if ALT-E is pressed","the record is edited."})

use S3PROD


SMALLS({||product}, "Product" ,nil, nil, nil,nil,bBlock)

//Smalls(expDisplayString,[cTitle],[expAlias],[expReturn],;
//                [expStartRange,expEndRange],[bException],[lForceCaps])

return



//--------------------------------------------------------------------------
static proc lookread
local cInscreen := savescreen(0,0,24,79)
local mProduct1 := space(10)
local mProduct2 := space(10)
local mProduct3 := space(10)
local mProduct4 := space(10)
local mState    := space(2)
memvar getlist
field product, state
select 1
use S3PROD
select 2
use S3STATES
SELECT 1

@ 0,0,24,79 BOX "ÚÄ¿³ÙÄÀ³ "
@ 1,4 SAY "Various lookup tables in GETs:"
@ 5,25 SAY "Pressing F2 here does a lookup on S3PROD.DBF"
@ 6,25 SAY "for PRODUCT - SMALLKSET()"
@ 8,25 SAY "If this get is left empty, a lookup is done on"
@ 9,25 SAY "S3PROD.DBF   - SMALLVALID()"
@ 11,25 SAY "This get is handled by SMALLWHEN() - the get is"
@ 12,25 SAY "never actually 'edited'"
@ 14,25 SAY "Here a lookup is done in S3STATES.DBF to validate"
@ 15,25 SAY "that this state IS IN that file - ISINLOOK()"
@ 16,25 SAY "If it is not, a lookup table is presented."
@ 18,25 SAY "Here, a lookup is done in S3PROD.DBF to validate"
@ 19,25 SAY "that this product is NOT IN that file - ISNOTDUP()"

SMALLKSET(K_F2,"lookread","mproduct1",{||product},"Product",1,"PRODUCT")

@5,4 get mProduct1
@8,4 get mProduct2 VALID smallvalid({||!empty(mProduct2)},;
                         {||product},"Product",1,"PRODUCT")
@11,4 get mProduct3 WHEN smallwhen(.f.,.f.,;
                           {||product},"Product",1,"PRODUCT")

@14,4 get mState VALID ;
  smallvalid({||ISINLOOK(mState,2,{||S3STATES->STATE},.F.,"Not a valid state")},;
  {||state},"States",2,"state")

@18,4 get mProduct4 valid ISNOTDUP(mProduct4,nil,{||s3prod->product},;
                          nil,nil,"Duplicate found")
RAT_READ(getlist)
ss_wipev(0,0,24,79,cInscreen)
select 1
use
select 2
use
return

