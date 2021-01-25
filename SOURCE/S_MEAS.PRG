#include "inkey.ch"
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION WGT_MEAS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  WGT_MEAS() A Weights and Measures conversion metafunction
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  WGT_MEAS()
ณ 
ณ  Description:
ณ  ------------
ณ  WGT_MEAS() is a menu driven Weights and Measure
ณ  conversion utility, which supports many types of conversions.
ณ 
ณ  Examples:
ณ  ---------
ณ   WGT_MEAS()
ณ 
ณ  Source:
ณ  -------
ณ  S_MEAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function wgt_meas
local i,nLast := 0
LOCAL nOldCursor     := setcursor(0)
LOCAL cInScreen      := Savescreen(0,0,24,79)
LOCAL cOldColor      := Setcolor(sls_normcol())
local nMenuChoice    := 1

*- draw boxes
@0,0,24,79 BOX sls_frame()
Setcolor(sls_popcol())
@1,1,12,40 BOX sls_frame()
@1,5 SAY '[Weights & Measures]'

DO WHILE .T.
  Setcolor(sls_popmenu())
  nMenuChoice := RAT_MENU2({;
                            {03,3 ,"Length Conversion  "},;
                            {04,3 ,"Area Conversion  "},;
                            {05,3 ,"Weight Conversion  "},;
                            {06,3 ,"Volume Conversion  "},;
                            {07,3 ,"Liquid Measure     "},;
                            {09,3 ,"Quit"}},nMenuChoice )

  Setcolor(sls_popcol())

  DO CASE
  CASE nMenuChoice = 0 .or. nMenuChoice = 6
    exit
  CASE nMenuChoice = 1 // length
    clength()
  CASE nMenuChoice = 2 // area
    carea()
  CASE nMenuChoice = 3 // weight
    cweight()
  CASE nMenuChoice = 4 // volume
    cvolume()
  CASE nMenuChoice = 5 // liquid measure
    cliquid()
  ENDCASE
END
Restscreen(0,0,24,79,cInScreen)
Setcolor(cOldColor)
setcursor(nOldCursor)
return nil

static function clength()
local aDesc := {;
                {"Quit                  ",nil},;
                {"Millimeters to Inches ",{|n|n*.039370079  }},;
                {"Millimeters to Feet   ",{|n|n*.0032808399 }},;
                {"Millimeters to Yards  ",{|n|n*.0010936133 }},;
                {"Millimeters to Miles  ",{|n|n*.0000006214 }},;
                {"Centimeters to Inches ",{|n|n*.39370079   }},;
                {"Centimeters to Feet   ",{|n|n*.032808399  }},;
                {"Centimeters to Yards  ",{|n|n*.010936133  }},;
                {"Centimeters to Miles  ",{|n|n*.0000062137 }},;
                {"Meters to Inches      ",{|n|n* 39.370079  }},;
                {"Meters to Feet        ",{|n|n* 3.2808399  }},;
                {"Meters to Yards       ",{|n|n* 1.0936133  }},;
                {"Meters to Miles       ",{|n|n*.00062137119}},;
                {"Kilometers to Inches  ",{|n|n* 39.370079  }},;
                {"Kilometers to Feet    ",{|n|n* 3280.8399  }},;
                {"Kilometers to Yards   ",{|n|n* 1093.6133  }},;
                {"Kilometers to Miles   ",{|n|n*.62137119   }},;
                {"Inches to Millimeters ",{|n|n* 25.40      }},;
                {"Inches to Centimeters ",{|n|n* 2.54       }},;
                {"Inches to Meters      ",{|n|n*.0254       }},;
                {"Inches to Kilometers  ",{|n|n*.0000254    }},;
                {"Feet to Millimeters   ",{|n|n* 304.8      }},;
                {"Feet to Centimeters   ",{|n|n* 30.48      }},;
                {"Feet to Meters        ",{|n|n*.3048       }},;
                {"Feet to Kilometers    ",{|n|n*.0003048    }},;
                {"Feet to Miles         ",{|n|n*.000189393  }},;
                {"Yards to Millimeters  ",{|n|n* 914.4      }},;
                {"Yards to Centimeters  ",{|n|n* 91.44      }},;
                {"Yards to Meters       ",{|n|n*.9144       }},;
                {"Yards to Kilometers   ",{|n|n*.0009144    }},;
                {"Yards to Miles        ",{|n|n*.0005682    }},;
                {"Miles to Millimeters  ",{|n|n* 1609344    }},;
                {"Miles to Centimeters  ",{|n|n* 160934.4   }},;
                {"Miles to Meters       ",{|n|n* 1609.344   }},;
                {"Miles to Kilometers   ",{|n|n* 1.609344   }},;
                {"Miles to Feet         ",{|n|n* 5280       }},;
                {"Miles to Yards        ",{|n|n* 1760       }}}
doconvert(aDesc)
return nil



static function carea()
local aDesc := {;
                {"Quit                         ",nil},;
                {"Sq Millimeters to Sq Inches  ",{|n|n*.0015500031      }},;
                {"Sq Millimeters to Sq Feet    ",{|n|n*.00001076391     }},;
                {"Sq Millimeters to Sq Yards   ",{|n|n*.00000119599     }},;
                {"Sq Centimeters to Sq Inches  ",{|n|n*.15500031        }},;
                {"Sq Centimeters to Sq Feet    ",{|n|n*.001076391       }},;
                {"Sq Centimeters to Sq Yards   ",{|n|n*.000119599       }},;
                {"Sq Meters to Sq Inches       ",{|n|n*1550.0031        }},;
                {"Sq Meters to Sq Feet         ",{|n|n*10.76391         }},;
                {"Sq Meters to Sq Yards        ",{|n|n*1.19599          }},;
                {"Sq Meters to Sq Miles        ",{|n|n*.00000038610216   }},;
                {"Sq Kilometers to Sq Feet     ",{|n|n*1076391          }},;
                {"Sq Kilometers to Sq Yards    ",{|n|n*1195990          }},;
                {"Sq Kilometers to Sq Miles    ",{|n|n*.38610216        }},;
                {"Sq Inches to Sq Millimeters  ",{|n|n*645.16           }},;
                {"Sq Inches to Sq Centimeters  ",{|n|n*6.4516           }},;
                {"Sq Inches to Sq Meters       ",{|n|n*.00064516        }},;
                {"Sq Feet to Sq Millimeters    ",{|n|n*92903.04         }},;
                {"Sq Feet to Sq Centimeters    ",{|n|n*929.0304         }},;
                {"Sq Feet to Sq Meters         ",{|n|n*.09290304        }},;
                {"Sq Feet to Sq Kilometers     ",{|n|n*000000929        }},;
                {"Sq Feet  to Acres            ",{|n|n*.00002296        }},;
                {"Sq Yards to Sq Millimeters   ",{|n|n*836100           }},;
                {"Sq Yards to Sq Centimeters   ",{|n|n*8361.2736        }},;
                {"Sq Yards to Sq Meters        ",{|n|n*0.83612736       }},;
                {"Sq Yards to Acres            ",{|n|n*0.00020661157    }},;
                {"Sq Miles to Sq Meters        ",{|n|n*2589988.1        }},;
                {"Sq Miles to Sq Kilometers    ",{|n|n*2.5899881        }},;
                {"Sq Miles to Acres            ",{|n|n*640              }},;
                {"Acres to Sq Feet             ",{|n|n*43560            }},;
                {"Acres to Sq Yards            ",{|n|n*4840             }},;
                {"Acres to Sq Miles            ",{|n|n*.0015626         }}}
doconvert(aDesc)
return nil

static function cweight()
local aDesc := {;
                {"Quit                       ",nil},;
                {"Milligrams to Ounces       ",{|n|n*.000035273962  }},;
                {"Milligrams to Pounds       ",{|n|n*.0000022046226 }},;
                {"Grams to Ounces            ",{|n|n*.03527396      }},;
                {"Grams to Pounds            ",{|n|n*.002204623     }},;
                {"Grams to Short Tons        ",{|n|n*.0000011023    }},;
                {"Killograms to Ounces       ",{|n|n*35.273962      }},;
                {"Killograms to Pounds       ",{|n|n*2.2046226      }},;
                {"Killograms to Short Tons   ",{|n|n*.0011023       }},;
                {"Metric Tons to Ounces      ",{|n|n*35273.962      }},;
                {"Metric Tons to Pounds      ",{|n|n*2204.6226      }},;
                {"Metric Tons to Short Tons  ",{|n|n*1.1023113      }},;
                {"Ounces to Milligrams       ",{|n|n*28349.523      }},;
                {"Ounces to Grams            ",{|n|n*28.349523      }},;
                {"Ounces to Killograms       ",{|n|n*.028349523     }},;
                {"Ounces to Pounds           ",{|n|n*.0625          }},;
                {"Ounces to Short Tons       ",{|n|n*.00003125      }},;
                {"Pounds to Milligrams       ",{|n|n*453592.37      }},;
                {"Pounds to Grams            ",{|n|n*453.59237      }},;
                {"Pounds to Killograms       ",{|n|n*.45359237      }},;
                {"Pounds to Ounces           ",{|n|n*16             }},;
                {"Pounds to Metric Tons      ",{|n|n*.00045359237   }},;
                {"Pounds to Short Tons       ",{|n|n*.0005          }},;
                {"Short Tons to Killograms   ",{|n|n*907.18474      }},;
                {"Short Tons to Ounces       ",{|n|n*32000.0        }},;
                {"Short Tons to Pounds       ",{|n|n*2000           }},;
                {"Short Tons to Metric Tons  ",{|n|n*0.90718474     }}}

doconvert(aDesc)
return nil

static function cvolume()
local aDesc := {;
                {"Quit                              ",nil},;
                {"Cubic Centimeters to Cubic Inches ",{|n|n*0.061023744 }},;
                {"Cubic Centimeters to Cubic Feet   ",{|n|n*.00003531467}},;
                {"Cubic Centimeters to Cubic Yards  ",{|n|n*.00000130795}},;
                {"Cubic Centimeters to Cubic Meters ",{|n|n*.000001     }},;
                {"Cubic Inches to Cubic Centimeters ",{|n|n*16.387064   }},;
                {"Cubic Inches to Cubic Feet        ",{|n|n*.0005787037 }},;
                {"Cubic Inches to Cubic Yards       ",{|n|n*.00002143347}},;
                {"Cubic Inches to Cubic Meters      ",{|n|n*.00001638706}},;
                {"Cubic Feet to Cubic Centimeters   ",{|n|n*28316.847   }},;
                {"Cubic Feet to Cubic Inches        ",{|n|n*1728        }},;
                {"Cubic Feet to Cubic Yards         ",{|n|n*0.03704     }},;
                {"Cubic Feet to Cubic Meters        ",{|n|n*0.028316847 }},;
                {"Cubic Yards to Cubic Centimeters  ",{|n|n*764554.86   }},;
                {"Cubic Yards to Cubic Inches       ",{|n|n*46656       }},;
                {"Cubic Yards to Cubic Feet         ",{|n|n*27          }},;
                {"Cubic Yards to Cubic Meters       ",{|n|n*0.76455486  }}}
doconvert(aDesc)
return nil

static function cliquid()
local aDesc := {;
                {"Quit                          ",nil},;
                {"Millileters to Liters         ",{|n|n*.001        }},;
                {"Millileters to Fluid Ounces   ",{|n|n*.03381497   }},;
                {"Millileters to Pints          ",{|n|n*.002113436  }},;
                {"Millileters to Quarts         ",{|n|n*.001057     }},;
                {"Millileters to Gallons        ",{|n|n*.0002642    }},;
                {"Liters to Millileters         ",{|n|n*1000        }},;
                {"Liters to Fluid Ounces        ",{|n|n*33.81497    }},;
                {"Liters to Pints               ",{|n|n*2.113436    }},;
                {"Liters to Quarts              ",{|n|n*1.056718    }},;
                {"Liters to Gallons             ",{|n|n*.2641794    }},;
                {"Fluid Ounces to Millileters   ",{|n|n*29.57352956 }},;
                {"Fluid Ounces to Liters        ",{|n|n*.029573529  }},;
                {"Fluid Ounces to Pints         ",{|n|n*.0625       }},;
                {"Fluid Ounces to Quarts        ",{|n|n*.03125      }},;
                {"Fluid Ounces to Gallons       ",{|n|n*.0078125    }},;
                {"Pints to Millileters          ",{|n|n*473.1631    }},;
                {"Pints to Liters               ",{|n|n*.4731631    }},;
                {"Pints to Fluid Ounces         ",{|n|n*16          }},;
                {"Pints to Quarts               ",{|n|n*.5          }},;
                {"Pints to Gallons              ",{|n|n*.125        }},;
                {"Quarts to Millileters         ",{|n|n*946.3263    }},;
                {"Quarts to Liters              ",{|n|n*.9463263    }},;
                {"Quarts to Fluid Ounces        ",{|n|n*32          }},;
                {"Quarts to Pints               ",{|n|n*2           }},;
                {"Quarts to Gallons             ",{|n|n*.25         }},;
                {"Gallons to Millileters        ",{|n|n*3785.306    }},;
                {"Gallons to Liters             ",{|n|n*3.785306    }},;
                {"Gallons to Fluid Ounces       ",{|n|n*128         }},;
                {"Gallons to Pints              ",{|n|n*8           }},;
                {"Gallons to Quarts             ",{|n|n*4           }}}
doconvert(aDesc)
return nil

//--------------------------------------------------------------------
static function doconvert(aConvert)
local nLastKey
local nRow := 1
local cBox := makebox(3,14,21,57)
local aSelect := A2TOSING(aConvert,1)
local nLastValue := 1
while .t.
  nRow := SACHOICE(4,15,20,56,aSelect,nil,nRow,nil,21,50,{||KBDESC()})
  if nRow = 1 .or. nRow == 0
    exit
  elseif nRow > 1
    nLastValue := doformula(aConvert[nRow,1],aConvert[nRow,2],@nLastValue)
  endif
end
unbox(cBox)
return nil
//--------------------------------------------------------------------
static function doformulA(cDesc,bFormula,nLastValue)
local nDecimals := SET(_SET_DECIMALS,5)
local cBox      := makebox( 6,7,13,73)
local getlist := {}
@ 7,9 SAY cDesc
@ 10,9 SAY "equals "
@ 12,9 SAY "ESC when done" color sls_normcol()
@9,34 SAY   left(cDesc,at(" to ",cDesc))
@10,34 SAY  subst(cDesc,at(" to ",cDesc)+4)
do while .t.
     @10,16 say eval(bFormula,nLastValue) pict "99999999.99999"
     @ 9,16 get nLastValue pict "99999999.99999"
     set cursor on
     rat_read(getlist,1,.f.,27,;
            {|r,c|iif(r=12 .and. c>=9 .and. c<=21,KBDESC(),nil)})
     set cursor off
     if lastkey()=27
       exit
     endif
enddo
unbox(cBox)
SET(_SET_DECIMALS,nDecimals)
return eval(bFormula,nLastValue)


//-------------------------------------------------------------
