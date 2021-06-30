echo off
cls
if x%1x==xx goto usage
echo   Compiling %1 -  CLIPPER.EXE assumed to be in path.
echo.
echo.
clipper %1
echo.
echo.
echo   Linking %1  -  CLIPPER.LIB, EXTEND.LIB , SUPER.LIB
echo                  assumed to be in current directory.
echo                  LINK.EXE assumed to be in path.
echo                  LINK.EXE assumed to be version 3.0 or above
echo.
echo.
LINK %1,,,clipper+extend+super /NOE /SE:512
goto end
:usage
echo.
echo.
echo.
echo USAGE      MSCOMP   [prg name]
echo.
echo.
echo.
:end
