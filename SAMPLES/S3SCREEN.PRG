
PROC MAIN
local cSuper, cInScreen, nDelay, cMessage
local c1stQtr   := savescreen(0,0,12,40)
local c2ndQtr   := savescreen(0,41,12,79)
local c3rdQtr   := savescreen(13,0,24,40)
local c4thQtr   := savescreen(13,41,24,79)
local nChoice,bDoBlock
SET WRAP ON
slsf_color("S3COLOR")
setcolor("+w/g,+g/n")
cSuper  := "S"+chr(15)+"u"+chr(31)+"p"+chr(47)+"e"+chr(63)+"r"+chr(79)+"L"+chr(95)+"i"+chr(111)+"b"+chr(127)+"!"+chr(11)
cSuper  := left(repl(cSuper,223),4000)
SS_RISE(0,0,24,79,cSuper)
cSuper  := "S"+chr(9)+"c"+chr(9)+"r"+chr(9)+"e"+chr(9)+"e"+chr(9)+"n"+chr(9)+"S"+chr(9)+"t"+chr(9)+"u"+chr(9)+"f"+chr(9)+"f"+chr(9)
cSuper  := left(repl(cSuper,96),2112)
dispbox(3,3,22,72,space(9))
SS_FADE(5,5,20,70,cSuper)
cInScreen := savescreen(5,5,20,70)
do while .t.
    nDelay   := nil
    cMessage := ""
    dispbox(5,24,20,51,space(9))
    scroll(6,25,19,50,0)
    nChoice := RAT_MENU2({;
                        {5 ,27 ,"1 Vertical Curtain"},;
                        {6 ,27 ,"2 Horiz Curtain"},;
                        {7 ,27 ,"3 Slice        "},;
                        {8 ,27 ,"4 Split        "},;
                        {9 ,27 ,"5 Fold         "},;
                        {10,27 ,"6 Rise         "},;
                        {11,27 ,"7 Fall         "},;
                        {12,27 ,"8 Fade         "},;
                        {13,27 ,"9 SlideRight   "},;
                        {14,27 ,"A SlideLeft    "},;
                        {15,27 ,"B Implode      "},;
                        {16,27 ,"C Close Vert   "},;
                        {17,27 ,"D Close Horiz  "},;
                        {18,27 ,"E Wipe Verti   "},;
                        {19,27 ,"E Wipe Horiz   "},;
                        {20,27 ,"Q Quit         "} },nChoice)
    do case
    case nChoice = 1
      bDoBlock := ;
         {||SS_VBLINDS(5,5,20,70,cInScreen,nDelay)}
      nDelay := 100
      cMessage := "(Smaller # is faster)"
    case nChoice = 2
      bDoBlock := ;
         {||SS_HBLINDS(5,5,20,70,cInScreen,nDelay)}
      nDelay := 50
      cMessage := "(Smaller # is faster)"
    case nChoice = 3
      bDoBlock :=;
         {||SS_slice(5,5,20,70,cInScreen,nDelay)}
      nDelay := 8
      cMessage := "(Larger # is faster)"
    case nChoice = 4
      bDoBlock :=;
         {||SS_split(5,5,20,70,cInScreen,nDelay)}
      nDelay := 5
      cMessage := "(Larger # is faster)"
    case nChoice = 5
      bDoBlock :=;
         {||SS_fold(5,5,20,70,cInScreen,nDelay)}
      nDelay := 3
      cMessage := "(Larger # is faster)"
    case nChoice = 6
      bDoBlock :=;
         {||SS_rise(5,5,20,70,cInScreen,nDelay)}
      nDelay := 100
      cMessage := "(Smaller # is faster)"
    case nChoice = 7
      bDoBlock :=;
         {||SS_fall(5,5,20,70,cInScreen,nDelay)}
      nDelay := 100
      cMessage := "(Smaller # is faster)"
    case nChoice = 8
      bDoBlock :=;
         {||SS_fade(5,5,20,70,cInScreen,nDelay)}
    case nChoice = 9
      bDoBlock :=;
         {||SS_slideright(5,5,20,70,cInScreen,nDelay)}
    case nChoice = 10
      bDoBlock :=;
         {||SS_slideleft(5,5,20,70,cInScreen,nDelay)}
    case nChoice = 11
      bDoBlock := ;
         {||ss_implode(5,5,20,70,cInScreen,nDelay)}
      nDelay := 100
      cMessage := "(Smaller # is faster)"
    case nChoice = 12
      bDoBlock := ;
         {||SS_closev(5,5,20,70,cInScreen,nDelay)}
      nDelay := 50
      cMessage := "(Smaller # is faster)"
    case nChoice = 13
      bDoBlock := ;
         {||SS_closeh(5,5,20,70,cInScreen,nDelay)}
      nDelay := 100
      cMessage := "(Smaller # is faster)"
    case nChoice = 14
      bDoBlock := ;
         {||SS_wipev(5,5,20,70,cInScreen,nDelay)}
      nDelay := 50
      cMessage := "(Smaller # is faster)"
    case nChoice = 15
      bDoBlock := ;
         {||SS_wipeh(5,5,20,70,cInScreen,nDelay)}
      nDelay := 100
      cMessage := "(Smaller # is faster)"
    case nChoice = 16 .or. nChoice = 0
         exit
    endcase
    if nDelay#nil .and. !messyn("Adjust Delay?","No","Yes")
      popread(.t.,"Delay:"+cMessage,@nDelay,"999")
    endif
    cInScreen := savescreen(5,5,20,70)
    dispbox(5,5,20,70,repl(chr(177),9))
    @12,25 say "Press a key to see the effect"
    rat_event(0)
    eval(bDoBlock)
enddo
ss_fall(0,0,12,40,c1stQtr )
inkey(.1)
ss_rise(0,41,12,79,c2ndQtr )
inkey(.1)
ss_fade(13,0,24,40,c3rdQtr )
inkey(.1)
ss_slideleft(13,41,24,79,c4thQtr )
inkey(.1)

