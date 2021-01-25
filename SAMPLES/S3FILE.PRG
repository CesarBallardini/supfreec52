
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
dispbegin()
cSuper  := "S"+chr(15)+"u"+chr(31)+"p"+chr(47)+"e"+chr(63)+"r"+chr(79)+"L"+chr(95)+"i"+chr(111)+"b"+chr(127)+"!"+chr(11)
cSuper  := left(repl(cSuper,223),4000)
restscreen(0,0,24,79,cSuper)
cSuper  := "F"+chr(9)+"i"+chr(9)+"l"+chr(9)+"e"+chr(9)+" "+chr(9)+"&"+chr(9)+" "+chr(9)+"D"+chr(9)+"i"+chr(9)+"r"+chr(9)+" "+chr(9)
cSuper  := left(repl(cSuper,96),2112)
dispbox(3,3,22,72,space(9))
restscreen(5,5,20,70,cSuper)
cInScreen := savescreen(5,5,20,70)
dispend()

aOptions := {;
            {"Full Directory - FULLDIR()  ",{||fulldir()} },;
            {"This Directory - POPUPDIR() ",{||popupdir(nil,nil,nil,nil,.t.)} },;
            {"Read Text File - FILEREAD() ",{||fileread(nil,nil,nil,nil,"*.prg")} },;
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


