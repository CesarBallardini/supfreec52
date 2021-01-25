// browse sampler

proc main
 local cInscreen := savescreen(0,0,24,79)
 local aMenuDef  := {;
                     {"Dbf  ","Browse DBF",{||bdbfsamp()} },;
                     {"MultiArray   ","Browse a Multi-dimmed array",{||b2dsamp()} },;
                     {"Delimited   ","Browse a Delimited file",{||bdelsamp()} },;
                     {"SDF   ","Browse an SDF file",{||bsdfsamp()} },;
                     {"Quit ","Exit the demo",nil};
                     }
 slsf_color("S3COLOR")
 initsup(.f.)
 setcolor(sls_normcol())
 dispbox(0,0,24,79,"ÚÄ¿³ÙÄÀ³±",sls_normcol())
 makebox(8,22,13,53)
 @ 9,24 SAY "SuperLib 3.0 Sample Program"
 @ 11,30 SAY "B R O W S I N G"


 @3,1 to 3,78

 slotusmenu(1,1,1,78,aMenudef,.f.,.f.,.f.)
 slotusclear()

 ss_fade(0,0,24,79,cInscreen)
return


static proc bdelsamp
    if !file("S3SAMPLE.ASC")
      msg("Missing file S3SAMPLE.ASC")
    else
      browsedelim("s3sample.asc",{"First","Last","Due","Date"},;
                       {"C","C","N","D"},;
                       {15,25,6,8})
    endif
return

static proc bsdfsamp
    if !file("S3SAMPLE.SDF")
      msg("Missing file S3SAMPLE.SDF")
    else
      browseSDF("s3sample.sdf",{"Last","First","Due","Date"},;
                         {"C","C","N","D"},;
                         {20,15,8,8})
    endif
return

static proc b2dsamp
    local a := directory()
    browse2d(5,5,20,60,a,{"File","Size","Date","Time","Attribute"},,;
      "Choose a File", {|k|amsg({k,"is not a valid key"})}  )
return

static proc bdbfsamp
    if !file("S3SAMPLE.DBF")
      msg("Missing file S3SAMPLE.DB?")
    else
      if snet_use("S3SAMPLE","S3SAMPLE",.F.,5,.T.,;
            "Unable to open S3SAMPLE. Keep trying?")
         editdb(.T.)
         use
      endif
    endif
return


