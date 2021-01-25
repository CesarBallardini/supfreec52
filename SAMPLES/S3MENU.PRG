

proc testmenu
local cInscreen := savescreen(0,0,24,79)
local nSelection
local nMenutype := 0
local aPDOptions := array(7)  // pulldown
local aPDDefs    := array(7)  // pulldown
local a123Def    := {;
                    {"Dbf  ","Browse DBF",{||msg("Selected Browse DBF")} },;
                    {"MultiArray   ","Browse a Multi-dimmed array",{||msg("Selected Browse Multi-dimmed array")} },;
                    {"Delimited   ","Browse a Delimited file",{||msg("Selected Browse a Delimited file")} },;
                    {"SDF   ","Browse an SDF file",;
                           {;
                             {"Weekly   ","Browse Weekly",{||msg("Selected Browse Weekly")} },;
                             {"Monthly  ","Browse Monthly",{||msg("Selected Browse Weekly")} },;
                             {"Yearly   ","Browse Yearly",{||msg("Selected Browse Weekly")} };
                           }},;
                    {"Quit ","Exit the demo",nil};
                    }         // 1-2-3 menu

local aFiles := a2tosing(directory(),1)  // get a dir of files for the
                                         // tabular menu

asize(aFiles,min(len(aFiles),10))
SET WRAP ON
slsf_color("S3COLOR")
initsup(.f.)
setcolor(sls_normcol())
dispbox(0,0,24,79,"ÚÄ¿³ÙÄÀ³±",sls_normcol())

definePD(aPDOptions,aPDDefs)     // define pulldown menu


while .t.
   nMenuType := menu_v("Menu type:","Pulldown","1-2-3","Tabular","Bungee (new!)","Quit")
   if nMenuType > 0 .and. nMenuType#5
      do case
      case nMenuType==1   // Pulldown
        nSelection := 1.01

        while nSelection #0 .and. nSelection#7.01
          nSelection := pulldn(nSelection,aPDOptions,aPDDefs)
          if nSelection #0 .and. nSelection#7.01
            aMsg( {"You've selected option:",nSelection } )
          endif
        end
      case nMenuType==2   // 1-2-3
        slotusmenu(1,1,1,78,a123def,.t.,.t.,.t.)
        slotusclear()
      case nMenuType==3   // tabular
         nSelection := pstabmenu(10,10,14,70,aFiles,"Select a file:")
      case nMenuType==4   // bungee
         dobungee()
      endcase
   else
     exit
   endif
end
ss_fall(0,0,24,79,cInscreen)





//------------define pulldown menu -----------------------------
static proc definePD(aPDOptions,aPDDefs)

*- menu choice definitions
aPDOptions[1] := "Files:Select:Define:Copy:Append:Field Copy:Export:Mailmerge"
aPDOptions[2] := "Indexes:Select:Order:New"
aPDOptions[3] := "Editing:Edit:Global Replace:Tabular Edit"
aPDOptions[4] := "Reporting:Build Query:Print Lists:Duplicates:Create Labels:Write Form Letters:Sum or Average a Field:DBF Field Frequency Analysis:Time Analysis:REPORT WRITER!:Statistics"
aPDOptions[5] := "Appearance:Screen Appearance:Predefined Colors"
aPDOptions[6] := "Utility:List text file:Directory:Todo List:Calendar:"+;
                 "Solar Calculator:Weights&Measures:Appointments"
aPDOptions[7] := "Quit:Quit"


*- menu boxes
aPDDefs[1] := .t.                // draw the top bar box ?
aPDDefs[2] := sls_normcol()      // top bar color string
aPDDefs[3] := sls_popmenu()      // drop box color
aPDDefs[4] := sls_frame()        // drop box frame
aPDDefs[5] := 3                  // drop box shadow position (1,3,7,9,0)
aPDDefs[6] := sls_shadatt()      // drop box shadow attribute
aPDDefs[7] := 0                  // row # of menu bar

return


  #include "Inkey.ch"
  #include "Box.ch"

  #translate CODEBLOCK(<b>) => <{b}>


  PROC DOBUNGEE()
  LOCAL lActive1  := .t., lActive2 := .t., lActive3:= .t.
  LOCAL bExitOk   := {||MESSYN("Exit now hoss?")}
  LOCAL aMiceHot  := { {23,3,23,12,CODEBLOCK(msg("The time is:"+time())) },;
                       {23,16,23,27,CODEBLOCK( bungeequit() )},;
                       {0,1,0,3,CODEBLOCK( bungeequit() )}  }

  LOCAL aKeysHot  := { {K_F10,CODEBLOCK(msg("The time is:"+time())) },;
                       {K_ALT_X,CODEBLOCK( bungeequit() )}  }

  LOCAL cInscreen := SAVESCREEN(0,0,24,79)
  LOCAL aMenu
  DISPBOX(0,0,24,79,B_DOUBLE+"±")
  @1,1 SAY PADC("Bungee Sampler",78) color "+W/W"

  @23,1 say padr("  [F10=time]   [ALT-X=exit]",78)
  @0,1 say "[þ]"

  bungstart()
  bungoption("Files")
       bungdrop()
       bungoption("Directory of files",{||popupdir()} )
       bungoption("Disk ~Space",{||msg("Disk Space:"+alltrim(str(diskspace())))} )
       bungoption("CROSSBAR")
       bungoption("e~Xit",{||bungeequit()} )
       bungundrop()
  bungoption("Memory")
       bungdrop()
       bungoption("Memory ~0",{||msg("Memory 0 :"+alltrim(str(memory(0))))} )
       bungoption("Memory ~1",{||msg("Memory 1 :"+alltrim(str(memory(1))))} )
       bungoption("Memory ~2",{||msg("Memory 2 :"+alltrim(str(memory(2))))} )
       bungundrop()
  bungoption("Dropdown")
       bungdrop()
       bungoption("Dropdown normally")
           bungdrop()
           bungoption("Option ~A",{||msg("Option A")})
           bungoption("Option ~B",{||msg("Option B")})
           bungoption("Option ~C",{||msg("Option C")})
           bungundrop()
       bungoption("Dro~pdown down 5,over 5")
           bungdrop(5,5)
           bungoption("Option ~A",{||msg("Option A")})
           bungoption("Option ~B",{||msg("Option B")})
           bungoption("Option ~C",{||msg("Option C")})
           bungundrop()
       bungoption("Dro~pdown down 0,over -5")
           bungdrop(0,-5)
           bungoption("Option ~A",{||msg("Option A")})
           bungoption("Option ~B",{||msg("Option B")})
           bungoption("Option ~C",{||msg("Option C")})
           bungundrop()
       bungundrop()

  bungoption("Activation")
       bungdrop()
       bungoption("Option ~A")
            bungdrop()
            bungoption("Option ~A",{||msg("Option A")},{||lActive1})
            bungoption("Option ~B",{||msg("Option B")},{||lActive2})
            bungoption("Option ~C",{||msg("Option C")},{||lActive3})
            bungoption("CROSSBAR")
            bungoption("Toggle Option A",{||lActive1 := !lActive1} )
            bungoption("T~oggle Option B",{||lActive2 := !lActive2} )
            bungoption("To~ggle Option C",{||lActive3 := !lActive3} )
            bungundrop()
       bungoption("Option ~B",{||msg("Option B")},{||lActive2})
       bungoption("Option ~C",{||msg("Option C")},{||lActive3})
       bungoption("CROSSBAR")
       bungoption("T~oggle Option B",{||lActive2 := !lActive2} )
       bungoption("To~ggle Option C",{||lActive3 := !lActive3} )
       bungundrop()

  aMenu := bungend()
  bungee(2,1,78,aMenu,nil,nil,aMiceHot,aKeysHot,bExitOk,nil,nil,1)

  restscreen(0,0,24,79,cInScreen)
RETURN

