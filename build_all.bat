@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"
title ZAIA Karaoke - Build All

echo ============================================================
echo  ZAIA Karaoke - Modern Edition  Beta 0.9.5  -  BUILD ALL
echo ============================================================
echo  Step 1: find or install .NET SDK 8
echo  Step 2: download build packages from nuget.org and build
echo  Step 3: create dist\ZaiaKaraoke.exe (runs without .NET installed)
echo  Internet is required. Nothing is written to your song library.
echo ============================================================
echo.

set "DOTNET="
call :find_sdk
if defined DOTNET goto build

echo .NET SDK 8 was NOT found on this PC.
echo This script can install it for you:
echo   A. with winget (system-wide, Windows may ask for permission), or
echo   B. a private copy inside this folder (.dotnet, about 600 MB, no admin)
echo.
choice /c YN /m "Install .NET SDK 8 now"
if errorlevel 2 goto no_sdk

where winget >nul 2>nul
if errorlevel 1 goto local_install
echo.
echo [1/3] Installing .NET SDK 8 with winget ...
winget install --id Microsoft.DotNet.SDK.8 -e --accept-source-agreements --accept-package-agreements
call :find_sdk
if defined DOTNET goto build
echo winget did not provide a usable SDK. Trying the private copy instead.

:local_install
echo.
echo [1/3] Downloading a private copy of .NET SDK 8 into "%~dp0.dotnet" ...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $f=Join-Path $env:TEMP 'zaia-dotnet-install.ps1'; Invoke-WebRequest -UseBasicParsing 'https://dot.net/v1/dotnet-install.ps1' -OutFile $f; & $f -Channel 8.0 -InstallDir '%~dp0.dotnet'"
call :find_sdk
if defined DOTNET goto build
goto no_sdk

:build
echo.
echo [2/3] Using .NET SDK: %DOTNET%
echo [3/3] Building ... (first time takes a few minutes)
echo.
"%DOTNET%" publish "src\Zaia.App\Zaia.App.csproj" -c Release -r win-x64 --self-contained true -o "dist" --nologo
if not errorlevel 1 if exist "dist\ZaiaKaraoke.exe" goto build_ok

echo.
echo The standalone build failed (usually nuget.org could not be reached).
echo Trying a normal build that uses the .NET already installed on this PC ...
echo.
if exist "src\Zaia.App\obj" rmdir /s /q "src\Zaia.App\obj"
if exist "src\Zaia.Core\obj" rmdir /s /q "src\Zaia.Core\obj"
"%DOTNET%" publish "src\Zaia.App\Zaia.App.csproj" -c Release -o "dist" --nologo
if errorlevel 1 goto build_failed
if not exist "dist\ZaiaKaraoke.exe" goto build_failed
echo.
echo NOTE: this build needs .NET 8 on the PC that runs it (this PC has it).
echo framework-dependent> "dist\BUILD_KIND.txt"
goto after_kind

:build_ok
echo self-contained> "dist\BUILD_KIND.txt"
:after_kind

echo.
echo ============================================================
echo  BUILD OK:  %~dp0dist\ZaiaKaraoke.exe
echo ============================================================
echo.
if /i "%~1"=="/quiet" goto done
choice /c YN /m "Create a shortcut on the Desktop"
if errorlevel 2 goto ask_run
powershell -NoProfile -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'ZAIA Karaoke.lnk')); $s.TargetPath='%~dp0dist\ZaiaKaraoke.exe'; $s.WorkingDirectory='%~dp0dist'; $s.Save()"
if errorlevel 1 echo Could not create the shortcut. You can still run dist\ZaiaKaraoke.exe

:ask_run
echo.
choice /c YN /m "Start ZAIA Karaoke now"
if errorlevel 2 goto done
start "" "dist\ZaiaKaraoke.exe"

:done
endlocal
exit /b 0

:build_failed
echo.
echo ============================================================
echo  BUILD FAILED
echo  Copy the lines above that contain the word "error"
echo  and send them back so they can be fixed.
echo ============================================================
pause
endlocal
exit /b 1

:no_sdk
echo.
echo .NET SDK 8 is required to build.
echo Install ".NET SDK 8.0 x64" from https://dotnet.microsoft.com/download/dotnet/8.0
echo then run build_all.bat again.
pause
endlocal
exit /b 1

:find_sdk
set "DOTNET="
if exist "%~dp0.dotnet\dotnet.exe" call :check_sdk "%~dp0.dotnet\dotnet.exe"
if defined DOTNET exit /b 0
if exist "%ProgramFiles%\dotnet\dotnet.exe" call :check_sdk "%ProgramFiles%\dotnet\dotnet.exe"
if defined DOTNET exit /b 0
where dotnet >nul 2>nul
if not errorlevel 1 call :check_sdk dotnet
exit /b 0

:check_sdk
%1 --list-sdks 2>nul | findstr /b /c:"8." >nul
if not errorlevel 1 set "DOTNET=%~1"
exit /b 0
