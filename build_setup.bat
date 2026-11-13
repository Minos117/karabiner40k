@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"
title ZAIA Karaoke - Build Setup

echo ============================================================
echo  ZAIA Karaoke - Modern Edition  Beta 0.9.5  -  BUILD SETUP
echo ============================================================
echo  Step 1: build the program (same as build_all.bat)
echo  Step 2: find or install Inno Setup 6 (free installer maker)
echo  Step 3: create release\ZaiaKaraoke-Setup-0.9.5.exe
echo ============================================================
echo.

call "%~dp0build_all.bat" /quiet
if errorlevel 1 exit /b 1
if not exist "dist\ZaiaKaraoke.exe" goto no_dist

set "ISCC="
call :find_iscc
if defined ISCC goto compile

echo.
echo Inno Setup 6 was NOT found on this PC.
echo It is a free program used only to create the Setup file.
choice /c YN /m "Install Inno Setup 6 now with winget"
if errorlevel 2 goto no_iscc
where winget >nul 2>nul
if errorlevel 1 goto no_iscc
winget install --id JRSoftware.InnoSetup -e --accept-source-agreements --accept-package-agreements
call :find_iscc
if not defined ISCC goto no_iscc

:compile
echo.
echo Using Inno Setup: %ISCC%
if not exist "release" mkdir "release"
"%ISCC%" /Qp "installer\ZaiaKaraoke.iss"
if errorlevel 1 goto setup_failed
if not exist "release\ZaiaKaraoke-Setup-0.9.5.exe" goto setup_failed

echo.
echo ============================================================
echo  SETUP READY:  %~dp0release\ZaiaKaraoke-Setup-0.9.5.exe
echo ============================================================
findstr /c:"framework-dependent" "dist\BUILD_KIND.txt" >nul 2>nul
if not errorlevel 1 echo  WARNING: this Setup needs ".NET 8 Desktop Runtime" on the target PC.
echo.
choice /c YN /m "Open the release folder"
if errorlevel 2 goto done
start "" "%~dp0release"

:done
endlocal
exit /b 0

:no_dist
echo The program was not built, so Setup cannot be created.
pause
endlocal
exit /b 1

:no_iscc
echo.
echo Inno Setup 6 is required to create the Setup file.
echo Install it from https://jrsoftware.org/isdl.php then run build_setup.bat again.
echo (The program itself is already built in the dist folder and can be used with run.bat.)
pause
endlocal
exit /b 1

:setup_failed
echo.
echo ============================================================
echo  SETUP BUILD FAILED
echo  Copy the lines above that contain the word "Error"
echo  and send them back so they can be fixed.
echo ============================================================
pause
endlocal
exit /b 1

:find_iscc
set "ISCC="
if exist "%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe" set "ISCC=%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
if defined ISCC exit /b 0
if exist "%ProgramFiles%\Inno Setup 6\ISCC.exe" set "ISCC=%ProgramFiles%\Inno Setup 6\ISCC.exe"
if defined ISCC exit /b 0
if exist "%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe" set "ISCC=%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe"
exit /b 0
