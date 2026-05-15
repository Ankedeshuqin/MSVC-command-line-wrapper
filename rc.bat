@rem Allows direct use of the MSVC rc command in the command line, automatically defines relevant macros and links relevant libraries, and uses the v141_xp toolset, x86 platform during compilation

@echo off
setlocal enabledelayedexpansion

@rem 1. Set the platform toolset directories

set PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.16.27023\bin\HostX86\x86;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\\bin;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\tools;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\ide;C:\Program Files (x86)\HTML Help Workshop;C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin;C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\;C:\WINDOWS\SysWow64;%PATH%
set INCLUDE=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.16.27023\include;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.16.27023\atlmfc\include;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\VS\include;C:\Program Files (x86)\Windows Kits\10\Include\10.0.10240.0\ucrt;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\include
set LIBPATH=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.16.27023\atlmfc\lib\x86;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.16.27023\lib\x86
set LIB=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.16.27023\lib\x86;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.16.27023\atlmfc\lib\x86;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\VS\lib\x86;C:\Program Files (x86)\Windows Kits\10\lib\10.0.10240.0\ucrt\x86;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\lib

@rem 2. Check if resource file arguments are included
set HAS_RES=0
for %%f in (%*) do (
    if /I "%%~xf"==".rc" set HAS_RES=1
)
if !HAS_RES!==0 (
    @rem No resource file arguments are passed, invoke the rc command directly
    rc %*
    exit /b
)

@rem 3. Compile the resource files
rc /D "_UNICODE" /D "UNICODE" /D "_USING_V110_SDK71_" /nologo %*

endlocal