@echo off
setlocal ENABLEDELAYEDEXPANSION

set "npdmFile=%1"

if "%npdmFile%"=="" (
    echo no npdm provided
    exit /b
)

hactool -t npdm --json=npdm.json !npdmFile!
exit      