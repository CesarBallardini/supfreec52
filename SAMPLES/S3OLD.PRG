#include "Inkey.ch"
#include "Box.ch"
#translate CODEBLOCK(<b>) => <{b}>

proc main

  LOCAL bExitOk   := {||MESSYN("Exit O.L.D. demonstartion ?")}
  LOCAL aMiceHot  := { {23,3,23,11,CODEBLOCK(old()) },;
                       {23,16,23,27,CODEBLOCK( bungeequit() )},;
                       {0,1,0,3,CODEBLOCK( bungeequit() )}  }

  LOCAL aKeysHot  := { {K_F1,CODEBLOCK(old() ) },;
                       {K_ALT_X,CODEBLOCK( bungeequit() )}  }

  LOCAL cInscreen := SAVESCREEN(0,0,24,79)
  LOCAL aMenu

  slsf_old("S3OLD")             // set name of O.L.D. file
  old_dev({|| OLD_MOD() })      // hook in the devlopment module

  if !openold()
     msg("Unable to create and/or open S3OLD.DBF and index")
     return
  endif

  sattcolor()
  setcolor(sls_normcol() )
  DISPBOX(0,0,24,79,B_DOUBLE+"±")
  @1,1 SAY PADC("O.L.D. (On Line Documentation) Sampler ",78) color "+W/W"

  @23,1 say padr("  [F1=help]    [ALT-X=exit]",78)
  @0,1 say "[þ]"

  bungstart()
  bungoption("Topics")
       bungdrop()
       bungoption("Topic A",{||old_topic("Topic A")} )
       bungoption("Topic B",{||old_topic("Topic B")} )
       bungoption("Topic C",{||old_topic("Topic C")} )
       bungoption("Topic D",{||old_topic("Topic D")} )
       bungoption("Topic E",{||old_topic("Topic E")} )
       bungoption("CROSSBAR")
       bungoption("e~Xit",{||bungeequit()} )
       bungundrop()
  bungoption("Help",{||OLD()} )

  aMenu := bungend()
  bungee(2,1,78,aMenu,{2,70},nil,aMiceHot,aKeysHot,bExitOk,nil,nil,1)

  restscreen(0,0,24,79,cInScreen)
RETURN



func openold
local lOldsOk := .f.
local cDocDbf := SLSF_OLD()
local cCr     := chr(13)+chr(10)
local cSomeText :=  ccr+ccr+"Here is the information. Modify it if you like"
IF !FILE(cDocDbf+".DBF")
        dbcreate(cDocDbf,{;
                      {"TOPIC","C",35,0},;
                      {"KEYS","M",10,0},;
                      {"TEXT","M",10,0};
                       })
    if snet_use(cDocDbf,"SLOLDS", .f., 5, .f.,"")  // open shared
        INDEX ON upper(field->TOPIC) TO (cDocDbf)
        SET INDEX TO ( cDocDbf)
        lOldsOk := .t.
        APPEND BLANK
        replace field->text with "Text for Topic A"+cSomeText, field->topic with ;
                "Topic A"
        APPEND BLANK
        replace field->text with "Text for Topic B"+cSomeText, field->topic with ;
                "Topic B"
        APPEND BLANK
        replace field->text with "Text for Topic C"+cSomeText, field->topic with ;
                "Topic C"
        APPEND BLANK
        replace field->text with "Text for Topic D"+cSomeText, field->topic with ;
                "Topic D"
        APPEND BLANK
        replace field->text with "Text for Topic E"+cSomeText, field->topic with ;
                "Topic E"
    endif
    MSG("Sample O.L.D. DBF created = S3OLD.DBF S3OLD.DBT S3OLD."+indexext() )
else
    lOldsOk := .t.
endif
use
return lOldsOk


