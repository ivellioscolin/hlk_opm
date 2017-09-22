@echo off
setlocal EnableDelayedExpansion

REM supported architecture amd64, x86
set arch=amd64

if /i '%1'=='amd64' (
	set arch=amd64
)

if /i '%1'=='x86' (
	set arch=x86
)

cd %arch%

REM Clean up
del /F /Q *.wtl
del /F /Q *.log

ShellRunner.exe -x premium -c WLP_Display_0099.pro -l "s98wtt_u.dll"

del /F /Q ShellRunner.ini
move /Y *.wtl ..
move /Y *.log ..

cd ..

:end
endlocal
echo off