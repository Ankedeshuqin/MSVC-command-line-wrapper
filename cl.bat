@rem Allows direct use of the MSVC cl command in the command line, automatically defines relevant macros and links relevant libraries, and uses the v141_xp toolset, x86 platform during compilation

@echo off
setlocal enabledelayedexpansion

@rem 1. Set the platform toolset directories

set PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.16.27023\bin\HostX86\x86;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\\bin;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\tools;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\ide;C:\Program Files (x86)\HTML Help Workshop;C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin;C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\;C:\WINDOWS\SysWow64;%PATH%
set INCLUDE=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.16.27023\include;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.16.27023\atlmfc\include;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\VS\include;C:\Program Files (x86)\Windows Kits\10\Include\10.0.10240.0\ucrt;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\include
set LIBPATH=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.16.27023\atlmfc\lib\x86;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.16.27023\lib\x86
set LIB=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.16.27023\lib\x86;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.16.27023\atlmfc\lib\x86;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\VS\lib\x86;C:\Program Files (x86)\Windows Kits\10\lib\10.0.10240.0\ucrt\x86;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\lib

@rem 2. Check if source file arguments are included, and separate source file, compilation options, and link options
set HAS_SOURCE=0
set SRCFILE_LIST=
set OBJ_LIST=
set COMPILE_ARGS=
set LINK_ARGS=
set SRC_EXTENSIONS=.c .cpp .cxx .cc
set IN_LINK=0
for %%f in (%*) do (
    @rem If /link is encountered, all subsequent arguments will be treated as link options
    if "%%f"=="/link" (
        set IN_LINK=1

    ) else if !IN_LINK!==1 (
        set LINK_ARGS=!LINK_ARGS! %%f

    ) else (
        set IS_SRC=0
        set EXT=%%~xf

        @rem Determine if it is a source file
        for %%s in (%SRC_EXTENSIONS%) do (
            if /I !EXT!==%%s set IS_SRC=1
        )
        if !IS_SRC!==1 (
            set HAS_SOURCE=1
            set SRCFILE_LIST=!SRCFILE_LIST! %%f
            set OBJ_LIST=!OBJ_LIST! %%~nf.obj

        ) else (
            @rem Other arguments (including link files) are treated as compilation arguments
            set COMPILE_ARGS=!COMPILE_ARGS! %%f
        )
    )
)
if !HAS_SOURCE!==0 (
    @rem No source file arguments are passed, invoke the cl command directly
    cl %*
    exit /b
)

@rem 3. First compile only for the source files to determine the subsystem (in this case, the link files in the compilation arguments will be ignored)
for %%f in (%SRCFILE_LIST%) do (
    cl /c /D "WIN32" /D "_UNICODE" /D "UNICODE" /D "_USING_V110_SDK71_" /utf-8 /nologo !COMPILE_ARGS! "%%f" >nul 2>&1 || (
        @rem If compilation fails, re-execute to display the error message and then exit
        cl /c /D "WIN32" /D "_UNICODE" /D "UNICODE" /D "_USING_V110_SDK71_" /utf-8 /nologo !COMPILE_ARGS! "%%f"
        exit /b 1
    )
)

@rem 4. Determine the subsystem
set SUBSYS=
for %%o in (!OBJ_LIST!) do (
    dumpbin /symbols %%o | findstr /r /c:"_main$" /c:"_wmain$" > nul
    if not errorlevel 1 (
        set SUBSYS=/SUBSYSTEM:CONSOLE,5.01

    ) else (
        dumpbin /symbols %%o | findstr /r /c:"_WinMain@16$" /c:"_wWinMain@16$" > nul
        if not errorlevel 1 (
            set SUBSYS=/SUBSYSTEM:WINDOWS,5.01
        )
    )
)

@rem 5. Re-compile
cl /D "WIN32" /D "_UNICODE" /D "UNICODE" /D "_USING_V110_SDK71_" /utf-8 /nologo !SRCFILE_LIST! !COMPILE_ARGS! kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /link !LINK_ARGS! !SUBSYS!

endlocal