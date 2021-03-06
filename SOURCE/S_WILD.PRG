/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION _WILDCARD()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  _WILDCARD() Wild Card String Compare
³ 
³  Returns:
³  --------
³  <lMatched> => match
³ 
³  Syntax:
³  -------
³  _wildcard(<cPattern>,<cTarget>)
³ 
³  Description:
³  ------------
³  <cPattern> is a model/wildcard pattern to search for
³  and <cTarget> is a string to compare with model/pattern in
³  <cPattern>.
³ 
³  Like DOS wildcards, but for a string.
³ 
³  <cPattern> is a string of wild cards interspersed
³  with literal text to compare against the contents of <cTarget>.
³  The following conventions for wild cards are followed:
³ 
³    1. "*"     stands for any group of characters.
³ 
³                W*r     gives fields beginning with
³                     "W", ending with "r".
³                *w*r    gives fields having "w"
³                    before last character "r".
³ 
³    2. "?"     stands for any single character.
³                J?n?s   gives Janes, Janus, Jones, and so
³                on.
³ 
³  Examples:
³  ---------
³   _wildcard("Pr?fon*e", "Prefontaine" )
³   // returns -> True
³ 
³   _wildcard("Pr?on*e", "Prefontaine" )
³   // returns -> False
³ 
³   _wildcard("Stei*er","Prefontaine")
³   // returns -> False
³ 
³  Notes:
³  -------
³  This was a C function in previous SuperLibs. Now 5.01
³  Clipper source code, and more reliable.
³ 
³  Source:
³  -------
³  S_WILD.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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


