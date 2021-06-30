echo off
cls
if x%1x==xx goto usage
echo Compiling %1 -  CLIPPER.EXE assumed to be on the path.
echo.
echo.
clipper %1
echo.
echo.
echo  TLinking %1  -  CLIPPER.LIB, EXTEND.LIB , SUPER.LIB
echo                  assumed to be in current directory.
echo                  TLINK.EXE assumed to be in path.
echo.
echo.
TLINK %1,,,clipper+extend+super
goto end
:usage
echo.
echo.
echo.
echo USAGE      TLCOMP   [prg name]
echo.
echo.
echo.
:end
