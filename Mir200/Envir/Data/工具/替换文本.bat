@echo off
chcp 65001 >nul
cls
@REM
setlocal
set config_xls=文本替换.xls
py -3 Python\ReplaceInXls.py ..\ ..\非官方表\ --config_xls "%config_xls%"

@REM 下面这个指令是上面指令的逆指令, 以 config_xls 为基础, 再还原回去, 有 git 在, 其实有点多余, 还有就是, 我也没有实现这个功能
@REM py -3 Python\ReplaceInXls.py ..\ ..\非官方表\ --config_xls "%config_xls%"  --revert
endlocal
pause
