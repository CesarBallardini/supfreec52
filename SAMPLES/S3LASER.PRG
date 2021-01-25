proc main
prnport()
set printer on
toprinter()
set printer off
set printer to


proc toprinter

//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
//-----set the CPI and LPI to defaults -----------------------------------
??SL_SETCPI(10)
??SL_SETLPI(6)


//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
//-draw 1st box ------------------------------------------------------------
?SL_BOX(10,10,20,20,"50",10)  // draw box 10,10, 20 20 with 50% shading
                             // and 10 DPI thick
?SL_GOTO(10,10)
??SL_ITALIC()+"Box 1"+SL_ITALICOFF()


//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
//-draw 2nd box ------------------------------------------------------------
?SL_BOX(12,12,22,22,"25",5)  // draws a box 12,12 to 22 22 with 25% shading
                             // and 5 DPI thick
?SL_GOTO(12,12)
??SL_BOLD()+"Box 2"+SL_NORMAL()



//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
//-draw 3rd box ------------------------------------------------------------
?SL_BOX(14,14,24,24,"100",5)  // draws a box 12,12 to 22 22 with 100% shading
                             // and 5 DPI thick
?SL_FILL(14,14,24,24,nil,"6") // fill the last box with pattern 6

?SL_GOTO(14,14)
??SL_BOLD()+"Box 3"+SL_NORMAL()


//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
//-----------DRAW  horiz lines
? SL_HLINE(30,5,30,35,"50",2)  // draws a line 30,5 to 30,75 with 50% shading
                                // AND 2 dpi THICK

? SL_HLINE(32,5,32,35,"100",5)  // draws a line 30,5 to 30,75 with 100% shading
                                // AND 5 dpi THICK

? SL_HLINE(34,5,34,35,"25",10)  // draws a line 30,5 to 30,75 with 100% shading
                                // AND 5 dpi THICK

//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
//--- draw vertical lines
? SL_VLINE(30,5,35,5,"50",2)  // draws a line 30,5 to 35,5 with 50% shading
                                // AND 2 dpi THICK

? SL_VLINE(30,10,35,10,"100",5)  // draws a line 30,10 to 35,10 with 100% shading
                                // AND 5 dpi THICK

? SL_VLINE(30,20,35,20,"25",10)  // draws a line 30,20 to 35,20 with 100% shading
                                // AND 5 dpi THICK



//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// -- show some of the font control functions
?SL_GOTO(40,0)

?? SL_SETCPI(16.66)

?"Compressed (16.66 CPI) and 6 LPI"
?"Compressed (16.66 CPI) and 6 LPI"
?"Compressed (16.66 CPI) and 6 LPI"

?
??SL_SETLPI(8)
?"Compressed (16.66 CPI) and 8 LPI"
?"Compressed (16.66 CPI) and 8 LPI"
?"Compressed (16.66 CPI) and 8 LPI"

?
??SL_SETLPI(12)
?"Compressed (16.66 CPI) and 12 LPI"
?"Compressed (16.66 CPI) and 12 LPI"
?"Compressed (16.66 CPI) and 12 LPI"
?
??SL_SETCPI(10)
??SL_SETLPI(6)
?"Normal (10 CPI and 6 LPI)"
?"Normal (10 CPI and 6 LPI)"
?"Normal (10 CPI and 6 LPI)"

??SL_BOLD()
?"BOLD (10 CPI and 6 LPI) "
?"BOLD (10 CPI and 6 LPI) "
?"BOLD (10 CPI and 6 LPI) "

??SL_NORMAL()+SL_ITALIC()
?"ITALIC (10 CPI and 6 LPI) "
?"ITALIC (10 CPI and 6 LPI) "
?"ITALIC (10 CPI and 6 LPI) "
??SL_ITALICOFF()


??SL_BOLD()

//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// --- draw some patterns and some shadings using SL_FILL()

?SL_FILL(5, 40,8,50,nil,"1") // fill pattern 1
??SL_downrow(1)+"Pattern 1"
?SL_FILL(9,40,12,50,nil,"2") // fill pattern 2
??SL_downrow(1)+"Pattern 2"
?SL_FILL(13,40,16,50,nil,"3") // fill pattern 3
??SL_downrow(1)+"Pattern 3"
?SL_FILL(17,40,20,50,nil,"4") // fill pattern 4
??SL_downrow(1)+"Pattern 4"
?SL_FILL(21,40,24,50,nil,"5") // fill pattern 5
??SL_downrow(1)+"Pattern 5"
?SL_FILL(25,40,28,50,nil,"6") // fill pattern 6
??SL_downrow(1)+"Pattern 6"

?SL_FILL(5, 60,8,70,"10")  // 10% fill
??SL_downrow(1)+"10% Fill"
?SL_FILL(9,60,12,70,"30")   // 30% fill
??SL_downrow(1)+"20% Fill"
?SL_FILL(13,60,16,70,"50")   // 50% fill
??SL_downrow(1)+"50% Fill"
?SL_FILL(17,60,20,70,"70")   // 70% fill
??SL_downrow(1)+"70% Fill"
?SL_FILL(21,60,24,70,"90")   // 90% fill
??SL_downrow(1)+"90% Fill"
?SL_FILL(25,60,28,70,"100")  // 100% fill
??SL_downrow(1)+"100% Fill"

??SL_NORMAL()

?sl_eject()
return
