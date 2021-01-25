/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION _WILDCARD()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  _WILDCARD() Wild Card String Compare
ณ 
ณ  Returns:
ณ  --------
ณ  <lMatched> => match
ณ 
ณ  Syntax:
ณ  -------
ณ  _wildcard(<cPattern>,<cTarget>)
ณ 
ณ  Description:
ณ  ------------
ณ  <cPattern> is a model/wildcard pattern to search for
ณ  and <cTarget> is a string to compare with model/pattern in
ณ  <cPattern>.
ณ 
ณ  Like DOS wildcards, but for a string.
ณ 
ณ  <cPattern> is a string of wild cards interspersed
ณ  with literal text to compare against the contents of <cTarget>.
ณ  The following conventions for wild cards are followed:
ณ 
ณ    1. "*"     stands for any group of characters.
ณ 
ณ                W*r     gives fields beginning with
ณ                     "W", ending with "r".
ณ                *w*r    gives fields having "w"
ณ                    before last character "r".
ณ 
ณ    2. "?"     stands for any single character.
ณ                J?n?s   gives Janes, Janus, Jones, and so
ณ                on.
ณ 
ณ  Examples:
ณ  ---------
ณ   _wildcard("Pr?fon*e", "Prefontaine" )
ณ   // returns -> True
ณ 
ณ   _wildcard("Pr?on*e", "Prefontaine" )
ณ   // returns -> False
ณ 
ณ   _wildcard("Stei*er","Prefontaine")
ณ   // returns -> False
ณ 
ณ  Notes:
ณ  -------
ณ  This was a C function in previous SuperLibs. Now 5.01
ณ  Clipper source code, and more reliable.
ณ 
ณ  Source:
ณ  -------
ณ  S_WILD.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function _wildcard(cModelString,cTargetString)
local nModelPosition, nTargetPosition,  nModelLen, nTargetLen
local cModelChar, cTargetChar, lMatchOk
local lDone := .f.

cTargetString   := rtrim(cTargetString)
cModelString    := rtrim(cModelString)
while "**"$cModelString .or. "*?"$cModelString  // get rid of any duplicate "**"
  cModelstring := strtran(cModelstring,"**","*")
  cModelstring := strtran(cModelstring,"*?","?")
end
nModelLen       := len(cModelString)
nTargetLen      := len(cTargetString)
nModelPosition  := 1
nTargetPosition := 1
lDone           := .f.
lMatchOk        := .t.

if (nTargetPosition <= nTargetLen) .and. (nModelPosition <= nModelLen)
   while !lDone

         cModelChar = subst(cModelString,nModelPosition,1)

         do case
         case cModelChar=="?"    // single character required
         case cModelChar#"*"    //  non wildcard character match required
            cTargetChar := subst(cTargetString,nTargetPosition,1)
            if cModelChar#cTargetChar
              lMatchOk  := .f.
              lDone     := .t.
            endif
         case cModelChar=="*"               // any group of characters (0,1,...)
            if nModelPosition == nModelLen  //last character in model is *
               lMatchOk   := .t.            //means rest of string can be
               lDone := .t.                 // anything
            else
               nModelPosition++
               cModelChar  := subst(cModelString,nModelPosition,1)
               cTargetChar := subst(cTargetString,nTargetPosition,1)
               while cTargetChar#cModelChar .and. ;
                     nTargetPosition <=nTargetLen
                 nTargetPosition++
                 if nTargetPosition <=nTargetLen
                   cTargetChar := subst(cTargetString,nTargetPosition,1)
                 else
                   lMatchOk := .f.
                   lDone := .t.
                 endif
               end
            endif
         endcase
         if !lDone
           nModelPosition++
           nTargetPosition++

           if nModelPosition > nModelLen .and. nTargetPosition > nTargetLen
              lDone := .t.
           elseif nModelPosition > nModelLen
              lMatchOk := .f.
              lDone := .t.
           elseif nTargetPosition > nTargetLen
              lMatchOk := .f.
              lDone    := .t.
              if nModelPosition==nModelLen
                if subst(cModelString,nModelPosition,1)=="*"
                  lMatchOk := .t.
                endif
              endif
           endif
         endif
   enddo
elseif nTargetLen==0 .and. cModelString=="*"  //if no target string, model
   lMatchOk  := .t.                           //must be "*"
elseif nTargetLen==0
   lMatchOk  := .f.
elseif nModelLen==0  // can't have no model - always .f.
   lMatchOk  := .f.
endif
return (lMatchOk)


