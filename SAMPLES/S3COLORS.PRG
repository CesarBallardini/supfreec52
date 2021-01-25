proc main
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

DOSCREEN()

aOptions := {;
            {"Full Interactive setting  - SETCOLORS() ",{||setcolors()} },;
            {"Pick from predefined list - COLPIK()) ",{||COLPIK()} },;
            {"Select from stored sets in S3COLORS.DBF - SATTPICK()",{||sattpick()} },;
            {"Save current set as DEFAULT in S3COLORS.DBF - SATTPUT()",{||sattput()} },;
            {"Browse current settings",{||showset()} },;
            {"Quit",nil};
            }
aSelect  := a2tosing(aOptions,1)

do while .t.

    nChoice := MCHOICE(aSelect)

    if nChoice = len(aOptions) .or. nChoice == 0
         exit
    else
         eval(aOptions[nChoice,2])
         doscreen()
    endif
enddo
ss_implode(0,0,24,79,cMainScreen)


//-----------------------------------------------------------------
static proc showset
local aSet := {;
              {"SLS_NORMCOL() ", "Normal screen output", left(sls_normcol(),30)},;
              {"SLS_NORMMENU()","Normal MENU color"   ,  left(sls_normmenu(),30)},;
              {"SLS_POPCOL()",  "Popup screen output" ,  left(sls_popcol(),30)},;
              {"SLS_POPMENU()", "Popup MENU color"    ,  left(sls_popmenu(),30)},;
              {"SLS_FRAME()"  , "Box frames"          ,  left(sls_frame(),9)},;
              {"SLS_SHADATT()", "Shadow attribute"    , str(sls_shadatt())},;
              {"SLS_SHADPOS()", "Shadow position"     , str(sls_shadpos())},;
              {"SLS_XPLODE()",  "Explode/implode"     , iif(sls_xplode(),"ON","OFF")};
              }

browse2d(5,2,20,78,aSet,{"Function/Setting","Description","Current Value "},,"Current Settings")
return



//-----------------------------------------------------------------
STATIC PROC DOSCREEN
local cStd,cEnh,cSuper
setcolor(sls_normcol())
DISPBEGIN()

cStd := alltrim(chr(standard()))
cEnh := alltrim(chr(enhanced()))
cSuper  := "S"+cEnh+"u"+cEnh+"p"+cEnh+"e"+cEnh+"r"+cEnh+"L"+cEnh+"i"+cEnh+"b"+cEnh+"!"+cEnh
cSuper  := left(repl(cSuper,223),4000)
restscreen(0,0,24,79,cSuper)

cSuper  := "C"+cStd+"o"+cStd+"l"+cStd+"o"+cStd+"r"+cStd+"s"+cStd+" "+cStd
cSuper  := left(repl(cSuper,180),2112)
dispbox(3,3,22,72,space(9))
restscreen(5,5,20,70,cSuper)
dispend()


