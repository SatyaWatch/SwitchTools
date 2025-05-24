@echo off
setlocal ENABLEDELAYEDEXPANSION

set "nsoFile=%~1"
if "%nsoFile%"=="" (
    echo error: no NSO provided
    echo Drag and drop the nso or give the path
    pause
    exit /b 1
)

for /f "tokens=2" %%A in ('
    nstool "%nsoFile%" ^| findstr /C:"ModuleId:"
') do set "moduleid=%%A"

if not defined moduleid (
    echo error: moduleid not found in output.
    pause
    exit /b 1
)

set "moduleid=%moduleid:~0,40%"
set "moduleid=%moduleid:a=A%"
set "moduleid=%moduleid:b=B%"
set "moduleid=%moduleid:c=C%"
set "moduleid=%moduleid:d=D%"
set "moduleid=%moduleid:e=E%"
set "moduleid=%moduleid:f=F%"

echo ModuleId: %moduleid%

echo %moduleid%| clip
echo (Copied to clipboard!)

pause
