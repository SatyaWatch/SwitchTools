@echo off
setlocal ENABLEDELAYEDEXPANSION

set /p version=enter version (e.g 19.0.1):

if "%version%"=="" (
    echo no version provided
    exit /b
)

if not exist "dumps\%version%" (
    echo folder dumps\%version% does not exist!
    exit /b
)


echo sysmodules extraction...
call S1_dumpVersion.bat %version% 0

echo applets extraction...
call S1_dumpVersion.bat %version% 1

echo ncas stuff
call S2_dumpNCAs.bat %version%

echo pkg2 stuff
call S3_dumpPackage2.bat %version%

echo DONE!
pause
