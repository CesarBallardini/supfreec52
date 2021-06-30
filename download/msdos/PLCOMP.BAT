echo off
cls
if x%1x==xx goto usage
echo Compiling %1 -  CLIPPER.EXE assumed to be on the path.
echo.
echo.
clipper %1
echo.
echo.
echo  PLinking %1  -  CLIPPER.LIB, EXTEND.LIB , SUPER.LIB
echo                  assumed to be in current directory.
echo                  PLINK86.EXE assumed to be in path.
echo.
echo.
PLINK86 fi %1 lib clipper,super,extend
goto end
:usage
echo.
echo.
echo.
echo USAGE      PLCOMP   [prg name]
echo.
echo.
echo.
:end
