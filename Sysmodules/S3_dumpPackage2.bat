@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

set "version=%1"

if "%version%"=="" (
    echo no version provided
    exit /b
)

hactoolnet -t pk21 ./dumps/%version%ERaw/bootImagePackage/nx/package2 --outdir ./dumps/%version%ERaw/bootImagePackage/nx
hactoolnet -t ini1 ./dumps/%version%ERaw/bootImagePackage/nx/INI1.bin --outdir ./dumps/%version%ERaw/bootImagePackage/nx

for %%F in (./dumps/%version%ERaw/bootImagePackage/nx/*.kip1) do (
    set "fullpath=%%F"
    set "filename=%%~nF"
	set "filename_lc=!filename!"
	call :tolower filename_lc
	set filename_lc

    echo kipping %%F to ./dumps/%version%ERaw/!filename_lc!.kip1
    hactoolnet -t kip1 ./dumps/%version%ERaw/bootImagePackage/nx/!filename!.kip1 --uncompressed ./dumps/%version%E/!filename_lc!.kip1
)

goto :EOF

:tolower
for %%L IN (a b c d e f g h i j k l m n o p q r s t u v w x y z) DO SET %1=!%1:%%L=%%L!
goto :EOF