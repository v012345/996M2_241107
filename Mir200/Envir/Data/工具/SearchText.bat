@echo off
chcp 65001 >nul
cls
@REM
setlocal
py -3 Python\SearchInXls.py ..\ ..\非官方表\
endlocal
pause
