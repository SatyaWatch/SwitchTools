@echo off
setlocal ENABLEDELAYEDEXPANSION

set "version=%1"
set "modulestext=%2"

if "%version%"=="" (
    echo no version provided
    exit /b
)

if "%modulestext%"=="" (
    echo no extraction mode
    exit /b
)

set inputfile=0.txt
set suffix=E
set rawsuffix=ERaw

if "%modulestext%"=="0" (
    set inputfile=title_sysmodules.txt
    set suffix=E
    set rawsuffix=ERaw
) else if "%modulestext%"=="1" (
    set inputfile=title_applets.txt
    set suffix=Applets
    set rawsuffix=AppletsRaw
) else (
    echo Invalid input mode!
    exit /b
)

for /f "usebackq tokens=*" %%L in ("%inputfile%") do (
    set "line=%%L"

    if not "!line!"=="" if "!line:~0,2!" NEQ "/*" (
        for /f "tokens=1,* delims=	 " %%A in ("!line!") do (
            set "id=%%A"
            set "name=%%B"
            
            echo hactoolnet !id! - !name!
            hactoolnet -t switchfs ./dumps/!version! --title !id! --exefsdir ./dumps/!version!!rawsuffix!/!name! --romfsdir ./dumps/!version!!rawsuffix!/!name! --outdir ./dumps/!version!!rawsuffix!/!name!
        )
    )
)

echo.
echo copying extracted main files to E/Applets
mkdir "dumps\%version%%suffix%" 2>nul

for /f "usebackq tokens=*" %%L in ("%inputfile%") do (
    set "line=%%L"

    if not "!line!"=="" if "!line:~0,2!" NEQ "/*" (
        for /f "tokens=1,* delims=	 " %%A in ("!line!") do (
            set "id=%%A"
            set "name=%%B"
            set "found="
            set "targetname="

            for /r "dumps\%version%%rawsuffix%\!name!" %%F in (main) do (
                if not defined found (
                    set "found=%%~fF"

                    set "fullpath=%%~dpF"
					
                    if "!fullpath:~-1!"=="\" set "fullpath=!fullpath:~0,-1!"
                    if "!fullpath:~-1!"=="/" set "fullpath=!fullpath:~0,-1!"

                    for %%X in ("!fullpath!") do (
                        set "parentfolder=%%~nxX"
                    )

                    set "targetname=!parentfolder!"
                )
            )

            if defined found (
                echo copying "!found!" to dumps\%version%%suffix%\!targetname!
                copy /Y "!found!" "dumps\%version%%suffix%\!targetname!" >nul
            ) else (
                echo no main file found for !name!
            )
        )
    )
)

