@echo off
setlocal ENABLEDELAYEDEXPANSION

set "version=%1"

if "%version%"=="" (
    echo no version provided
    exit /b
)

set tempfile=_nca_list.txt
set sysmapping=_sysmodules_map.txt
set appletmapping=_applets_map.txt

hactoolnet -t switchfs ./dumps/%version% --listncas > %tempfile%

del "%sysmapping%" 2>nul
(for /f "usebackq tokens=1,* delims=	 " %%A in ("title_sysmodules.txt") do (
    if not "%%A"=="" if not "%%A:~0,2"=="/*" echo %%A=%%B
)) >> "%sysmapping%"


del "%appletmapping%" 2>nul
(for /f "usebackq tokens=1,* delims=	 " %%A in ("title_applets.txt") do (
    if not "%%A"=="" if not "%%A:~0,2"=="/*" echo %%A=%%B
)) >> "%appletmapping%"

for /f "tokens=1,2,3" %%A in (%tempfile%) do (
    set "ncaid=%%A"
    set "type=%%B"
    set "titleid=%%C"

    if /i not "!type!"=="Program" (
        set "folder=!ncaid!"
        set "targetsubdir=UndefNCAs"
        for /f "tokens=1,2 delims==" %%X in (%sysmapping%) do (
            if "%%X"=="!titleid!" (
                set "folder=%%Y"
                set "targetsubdir=ERaw"
            )
        )

        if "!targetsubdir!"=="UndefNCAs" (
            for /f "tokens=1,2 delims==" %%X in (%appletmapping%) do (
                if "%%X"=="!titleid!" (
                    set "folder=%%Y"
                    set "targetsubdir=AppletsRaw"
                )
            )
        )

        echo processing !ncaid! - title: !titleid! - target: dumps/%version%!targetsubdir!/!folder!/
        mkdir "./dumps/%version%!targetsubdir!/!folder!" 2>nul

        hactoolnet -t nca --exefsdir ./dumps/%version%!targetsubdir!/!folder!/ --romfsdir ./dumps/%version%!targetsubdir!/!folder!/ --listromfs ./dumps/%version%/!ncaid!.nca
    ) else (
        echo Skipping Program NCA: !ncaid!
    )
)

del %tempfile%
del %sysmapping%
del %appletmapping%
