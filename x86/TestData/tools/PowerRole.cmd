@echo off

setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

if "%1"=="" goto ERR_MISSING_ARG
if not exist PowerRole.exe goto ERR_MISSING_POWERROLE_EXE
if not exist PowerRole.vbs goto ERR_MISSING_POWERROLE_VBS

set PowerModes=%1

REM Determine if this is a laptop or desktop then set power source
set LaptopOrDesktop=Laptop
if exist ThisIsADesktop.txt del /q /s ThisIsADesktop.txt
PowerRole.exe > PowerRole.txt
for /f %%J in ('findstr /i /C:"BatteryFlag = 128" PowerRole.txt') do set LaptopOrDesktop=Desktop
if /I "%LaptopOrDesktop%"=="Desktop" (
   echo.
   echo This is a desktop, no need to switch to DC > ThisIsADesktop.txt
   echo This is a desktop, no need to switch to DC
   echo.
   goto EOF
)

if /I "%PowerModes%"=="DC" goto DCPowerSourceLoop
if /I "%PowerModes%"=="AC" goto ACPowerSourceLoop

echo.
echo Error - invalid PowerMode arg
echo.
goto ERR_MISSING_ARG

:ACPowerSourceLoop
    echo enter ACPowerSourceLoop
    set CurrentPowerSource=
    PowerRole.exe > PowerRole.txt
    for /f %%J in ('findstr /i /C:"ACLineStatus = 1" PowerRole.txt') do set CurrentPowerSource=AC
    for /f %%J in ('findstr /i /C:"ACLineStatus = 0" PowerRole.txt') do set CurrentPowerSource=DC
    echo CurrentPowerSource=!CurrentPowerSource!
    if /I "!CurrentPowerSource!"=="AC" (goto ACPowerSourceLoopEnd)
    cscript /nologo PowerRole.vbs "Please switch the power source to AC!"
    goto ACPowerSourceLoop

:ACPowerSourceLoopEnd
goto EOF


:DCPowerSourceLoop
    echo enter DCPowerSourceLoop
    set CurrentPowerSource=
    PowerRole.exe > PowerRole.txt
    for /f %%J in ('findstr /i /C:"ACLineStatus = 1" PowerRole.txt') do set CurrentPowerSource=AC
    for /f %%J in ('findstr /i /C:"ACLineStatus = 0" PowerRole.txt') do set CurrentPowerSource=DC
    echo CurrentPowerSource=!CurrentPowerSource!
    if /I "!CurrentPowerSource!"=="DC" (goto DCPowerSourceLoopEnd)
    cscript /nologo PowerRole.vbs "Please switch the power source to DC!"
    goto DCPowerSourceLoop
:DCPowerSourceLoopEnd
goto EOF

:ERR_MISSING_ARG
echo.
echo  Missing argument!  AC or DC are valid args
echo.
pause
goto EOF

:ERR_MISSING_POWERROLE_EXE
echo.
echo  Missing PowerRole.exe!
echo.
pause
goto EOF

:ERR_MISSING_POWERROLE_VBS
echo.
echo  Missing PowerRole.vbs!
echo.
pause
goto EOF

:EOF
if exist PowerRole.txt del /q /s PowerRole.txt
exit /B 0