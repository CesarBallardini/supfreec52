
#include "inkey.ch"

proc main
// first, set the name of the help file to S3HELP
slsf_help("S3HELP")
slsf_color("S3COLOR")
initsup(.f.)
setcolor(sls_popcol())
helptest()


//-------------------------------------------
proc helptest
local v1 := space(10)
local v2 := date()
local v3 := time()
local v4 := .f.
local v5 := 123.45
local cInfo := makebox(19,0,23,60)
local cBox  := makebox(9,9,15,30)
memvar getlist

SET KEY K_F1 to help
SET KEY K_ALT_F1 TO helpmod

@21,2 say "Press F1 for help. Press ALT-F1 to modify help."

@10,10 get v1
@11,10 get v2
@12,10 get v3
@13,10 get v4
@14,10 get v5
read
unbox(cBox)
unbox(cInfo)
return








