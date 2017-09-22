@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

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

REM Clean up
del /F /Q *.wtl
del /F /Q wttsdk.log

REM Prepare content files
mkdir .\DXVAContent
xcopy .\DXVAContentRoot\*.* .\DXVAContent /Y

REM Add CP reg
cmd /c REG ADD "HKLM\SOFTWARE\Microsoft\Windows Media Foundation\ContentProtection" /f /v EnableClassicActivationOfITA /t REG_DWORD /d 1

.\%arch%\TE.exe /enablewttlogging /appendwttlogging .\amd64\mftdmediaengine.dll /name:CMediaEngineTests::H264DRMTest1 /p:"ContentSource=./DXVAContent" /p:"GUID=#{DETECT}#"
ren Te.wtl H264DRMTest1.wtl
.\%arch%\TE.exe /enablewttlogging /appendwttlogging .\amd64\mftdmediaengine.dll /name:CMediaEngineTests::H264DRMTest2 /p:"ContentSource=./DXVAContent" /p:"GUID=#{DETECT}#"
ren Te.wtl H264DRMTest2.wtl
.\%arch%\TE.exe /enablewttlogging /appendwttlogging .\amd64\mftdmediaengine.dll /name:CMediaEngineTests::H264DRMTest3 /p:"ContentSource=./DXVAContent" /p:"GUID=#{DETECT}#"
ren Te.wtl H264DRMTest3.wtl
.\%arch%\TE.exe /enablewttlogging /appendwttlogging .\amd64\mftdmediaengine.dll /name:CMediaEngineTests::H264DRMTest4 /p:"ContentSource=./DXVAContent" /p:"GUID=#{DETECT}#"
ren Te.wtl H264DRMTest4.wtl
.\%arch%\TE.exe /enablewttlogging /appendwttlogging .\amd64\mftdmediaengine.dll /name:CMediaEngineTests::H264DRMTest5 /p:"ContentSource=./DXVAContent" /p:"GUID=#{DETECT}#"
ren Te.wtl H264DRMTest5.wtl
.\%arch%\TE.exe /enablewttlogging /appendwttlogging .\amd64\mftdmediaengine.dll /name:CMediaEngineTests::HEVCDRMTest6 /p:"ContentSource=./DXVAContent" /p:"GUID=#{DETECT}#"
ren Te.wtl HEVCDRMTest6.wtl
.\%arch%\TE.exe /enablewttlogging /appendwttlogging .\amd64\mftdmediaengine.dll /name:CMediaEngineTests::HEVCDRMTest7 /p:"ContentSource=./DXVAContent" /p:"GUID=#{DETECT}#"
ren Te.wtl HEVCDRMTest7.wtl
.\%arch%\TE.exe /enablewttlogging /appendwttlogging .\amd64\mftdmediaengine.dll /name:CMediaEngineTests::HEVCDRMTest8 /p:"ContentSource=./DXVAContent" /p:"GUID=#{DETECT}#"
ren Te.wtl HEVCDRMTest8.wtl
.\%arch%\TE.exe /enablewttlogging /appendwttlogging .\amd64\mftdmediaengine.dll /name:CMediaEngineTests::HEVCDRMTest9 /p:"ContentSource=./DXVAContent" /p:"GUID=#{DETECT}#"
ren Te.wtl HEVCDRMTest9.wtl
.\%arch%\TE.exe /enablewttlogging /appendwttlogging .\amd64\mftdmediaengine.dll /name:CMediaEngineTests::HEVCDRMTest10 /p:"ContentSource=./DXVAContent" /p:"GUID=#{DETECT}#"
ren Te.wtl HEVCDRMTest10.wtl

REM Remove content files
rmdir /S /Q .\DXVAContent

REM Del CP reg
cmd /c REG DELETE "HKLM\SOFTWARE\Microsoft\Windows Media Foundation\ContentProtection" /f

:end
endlocal
echo off